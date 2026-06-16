local lsp_state = { progress = "" }
local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥", "", "" }

local tn_colors = {
	fg = "#c0caf5", subtext0 = "#a9b1d6", surface0 = "#2f3346", none = "NONE",
	blue = "#7aa2f7", green = "#9ece6a", red = "#f7768e", teal = "#73daca",
	yellow = "#e0af68", orange = "#ff9e64", magenta = "#bb9af7", cyan = "#7dcfff",
	comment = "#565f89", bg_highlight = "#292e42",
}

vim.api.nvim_create_autocmd("LspProgress", {
	group = vim.api.nvim_create_augroup("LualineLspProgress", { clear = true }),
	pattern = { "begin", "report", "end" },
	callback = function(args)
		local data = args.data and args.data.params and args.data.params.value
		if not data then return end
		if data.kind == "end" then
			lsp_state.progress = ""
		else
			local pct = data.percentage or 0
			local idx = 1 + ((pct - pct % 10) / 10)
			local progress = ""
			if data.message then
				local start, stop = data.message:find("^%d+/%d+")
				if start then progress = data.message:sub(start, stop) end
			end
			lsp_state.progress = spinners[idx] .. " " .. tostring(pct) .. "%% " .. (data.title or "") .. (progress ~= "" and " " .. progress or "")
		end
		pcall(vim.cmd.redrawstatus)
	end,
})

local transparent = require("core.settings").transparent_background

return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics", true),
		git = require("modules.utils.icons").get("git", true),
		git_nosep = require("modules.utils.icons").get("git"),
		misc = require("modules.utils.icons").get("misc", true),
		ui = require("modules.utils.icons").get("ui", true),
		aichat = require("modules.utils.icons").get("aichat", true),
	}

	local universal_bg = transparent and tn_colors.none or tn_colors.bg_highlight

	local function lualine_theme()
		return {
			normal = {
				a = { fg = tn_colors.blue, bg = tn_colors.surface0, gui = "bold" },
				b = { fg = tn_colors.fg, bg = universal_bg },
				c = { fg = tn_colors.fg, bg = universal_bg },
			},
			command = { a = { fg = tn_colors.orange, bg = tn_colors.surface0, gui = "bold" } },
			insert = { a = { fg = tn_colors.green, bg = tn_colors.surface0, gui = "bold" } },
			visual = { a = { fg = tn_colors.magenta, bg = tn_colors.surface0, gui = "bold" } },
			terminal = { a = { fg = tn_colors.teal, bg = tn_colors.surface0, gui = "bold" } },
			replace = { a = { fg = tn_colors.red, bg = tn_colors.surface0, gui = "bold" } },
			inactive = {
				a = { fg = tn_colors.subtext0, bg = universal_bg, gui = "bold" },
				b = { fg = tn_colors.subtext0, bg = universal_bg },
				c = { fg = tn_colors.subtext0, bg = universal_bg },
			},
		}
	end

	local conditionals = {
		has_enough_room = function() return vim.o.columns > 100 end,
		has_comp_before = function() return vim.bo.filetype ~= "" end,
		has_git = function()
			return #vim.fs.find(".git", { limit = 1, upward = true, type = "directory", path = vim.fn.expand("%:p:h") }) > 0
		end,
	}

	local utils = {
		force_centering = function() return "%=" end,
		abbreviate_path = function(path)
			local home = require("core.global").home
			if path:find(home, 1, true) == 1 then path = "~" .. path:sub(#home + 1) end
			return path
		end,
		gen_hl = function(fg, _, special_nobg, bg, gui)
			local color = tn_colors[fg] or fg
			local nobg = special_nobg and transparent
			return { fg = color, bg = nobg and tn_colors.none or bg and tn_colors[bg] or nil, gui = gui or nil }
		end,
	}

	local function diff_source()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	local components = {
		separator = { -- use as section separators
			function()
				return "│"
			end,
			padding = 0,
			color = utils.gen_hl("surface1", true, true),
			separator = { left = "", right = "" },
		},

		file_status = {
			function()
				local function is_new_file()
					local filename = vim.fn.expand("%")
					return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
				end

				local symbols = {}
				if vim.bo.modified then
					table.insert(symbols, "[+]")
				end
				if vim.bo.modifiable == false then
					table.insert(symbols, "[-]")
				end
				if vim.bo.readonly == true then
					table.insert(symbols, "[RO]")
				end
				if is_new_file() then
					table.insert(symbols, "[New]")
				end
				return #symbols > 0 and table.concat(symbols, "") or ""
			end,
			padding = { left = -1, right = 1 },
			cond = conditionals.has_comp_before,
		},

		lsp = {
			function()
				local buf_ft = vim.bo.filetype
				local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
				local lsp_lists = {}
				local available_servers = {}
				if next(clients) == nil then
					return icons.misc.NoActiveLsp -- No server available
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					local client_name = client.name
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						-- Avoid adding servers that already exist.
						if not lsp_lists[client_name] then
							lsp_lists[client_name] = true
							table.insert(available_servers, client_name)
						end
					end
				end

				return next(available_servers) == nil and icons.misc.NoActiveLsp
					or string.format(
						"%s[%s] %s",
						icons.misc.LspAvailable,
						table.concat(available_servers, ", "),
						lsp_state.progress
					)
			end,
			color = utils.gen_hl("blue", true, true, nil, "bold"),
			cond = conditionals.has_enough_room,
		},

		chat_progress = {
			(function()
				local processing = false
				local animate_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				local animation_idx = 1
				vim.api.nvim_create_autocmd("User", {
					pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
					group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true }),
					callback = function(args)
						processing = (args.match == "CodeCompanionRequestStarted")
					end,
				})

				return function()
					if not processing then
						return ""
					end
					animation_idx = animation_idx % #animate_chars + 1
					return string.format("%s %s", icons.aichat.Copilot, animate_chars[animation_idx])
				end
			end)(),
			color = utils.gen_hl("yellow", true, true),
			cond = conditionals.has_enough_room,
		},

		python_venv = {
			function()
				local function env_cleanup(venv)
					if string.find(venv, "/") then
						local final_venv = venv
						for w in venv:gmatch("([^/]+)") do
							final_venv = w
						end
						venv = final_venv
					end
					return venv
				end

				if vim.bo.filetype == "python" then
					local venv = vim.env.CONDA_DEFAULT_ENV
					if venv then
						return icons.misc.PyEnv .. env_cleanup(venv)
					end
					venv = vim.env.VIRTUAL_ENV
					if venv then
						return icons.misc.PyEnv .. env_cleanup(venv)
					end
				end
				return ""
			end,
			color = utils.gen_hl("green", true, true),
			cond = conditionals.has_enough_room,
		},

		tabwidth = {
			function()
				return icons.ui.Tab .. vim.bo.tabstop
			end,
			padding = 1,
		},

		cwd = {
			function()
				return icons.ui.FolderWithHeart .. utils.abbreviate_path(vim.fs.normalize(vim.uv.cwd()))
			end,
			color = utils.gen_hl("subtext0", true, true, nil, "bold"),
		},

		file_location = {
			function()
				local cursorline = vim.fn.line(".")
				local cursorcol = vim.fn.virtcol(".")
				local filelines = vim.fn.line("$")
				local position
				if cursorline == 1 then
					position = "Top"
				elseif cursorline == filelines then
					position = "Bot"
				else
					position = string.format("%2d%%%%", math.floor(cursorline / filelines * 100))
				end
				return string.format("%s · %3d:%-2d", position, cursorline, cursorcol)
			end,
		},
	}

	require("modules.utils").load_plugin("lualine", {
		options = {
			icons_enabled = true,
			theme = lualine_theme(),
			disabled_filetypes = { statusline = { "alpha" } },
			component_separators = "",
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				{
					"filetype",
					colored = true,
					icon_only = false,
					icon = { align = "left" },
				},
				components.file_status,
				vim.tbl_extend("force", components.separator, {
					cond = function()
						return conditionals.has_git() and conditionals.has_comp_before()
					end,
				}),
			},
			lualine_c = {
				{
					"branch",
					icon = icons.git_nosep.Branch,
					color = utils.gen_hl("subtext0", true, true, nil, "bold"),
					cond = conditionals.has_git,
				},
				{
					"diff",
					symbols = {
						added = icons.git.Add,
						modified = icons.git.Mod_alt,
						removed = icons.git.Remove,
					},
					source = diff_source,
					colored = false,
					color = utils.gen_hl("subtext0", true, true),
					cond = conditionals.has_git,
					padding = { right = 1 },
				},

				{ utils.force_centering },
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					symbols = {
						error = icons.diagnostics.Error,
						warn = icons.diagnostics.Warning,
						info = icons.diagnostics.Information,
						hint = icons.diagnostics.Hint_alt,
					},
				},
				components.lsp,
			},
			lualine_x = {
				components.chat_progress,
				{
					"encoding",
					show_bomb = true,
					fmt = string.upper,
					padding = { left = 1 },
					cond = conditionals.has_enough_room,
				},
				{
					"fileformat",
					symbols = {
						unix = "LF",
						dos = "CRLF",
						mac = "CR", -- Legacy macOS
					},
					padding = { left = 1 },
				},
				components.tabwidth,
			},
			lualine_y = {
				components.separator,
				components.python_venv,
				components.cwd,
			},
			lualine_z = { components.file_location },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = {},
	})
end
