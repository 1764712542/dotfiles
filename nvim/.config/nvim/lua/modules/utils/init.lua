local M = {}

---@class palette
---@field rosewater string
---@field flamingo string
---@field mauve string
---@field pink string
---@field red string
---@field maroon string
---@field peach string
---@field yellow string
---@field green string
---@field sapphire string
---@field blue string
---@field sky string
---@field teal string
---@field lavender string
---@field text string
---@field subtext1 string
---@field subtext0 string
---@field overlay2 string
---@field overlay1 string
---@field overlay0 string
---@field surface2 string
---@field surface1 string
---@field surface0 string
---@field base string
---@field mantle string
---@field crust string
---@field none "NONE"

---@type nil|palette
local palette = nil

-- Indicates if autocmd for refreshing the builtin palette has already been registered
---@type boolean
local _has_autocmd = false

---Initialize the palette
---@return palette
local function init_palette()
	-- Reinitialize the palette on event `ColorScheme`
	if not _has_autocmd then
		_has_autocmd = true
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("__builtin_palette", { clear = true }),
			pattern = "*",
			callback = function()
				palette = nil
				init_palette()
				-- Also refresh hard-coded hl groups
				M.gen_alpha_hl()
				M.gen_lspkind_hl()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end

	if not palette then
		palette = {
			rosewater = "#dc8a78",
			flamingo = "#dd7878",
			mauve = "#cba6f7",
			pink = "#f5c2e7",
			red = "#f7768e",
			maroon = "#b33076",
			peach = "#ff9e64",
			yellow = "#e0af68",
			green = "#9ece6a",
			sapphire = "#36d0e0",
			blue = "#7aa2f7",
			sky = "#04a5e5",
			teal = "#73daca",
			lavender = "#bb9af7",

			text = "#c0caf5",
			subtext1 = "#b8c0e0",
			subtext0 = "#a9b1d6",
			overlay2 = "#9aa5ce",
			overlay1 = "#8b96b8",
			overlay0 = "#7a85a3",
			surface2 = "#4c5173",
			surface1 = "#3b4261",
			surface0 = "#2f3346",

			base = "#1a1b26",
			mantle = "#24283b",
			crust = "#1d202f",
		}

		palette = vim.tbl_extend("force", { none = "NONE" }, palette, require("core.settings").palette_overwrite)
	end

	return palette
end

---@param c string @The color in hexadecimal.
local function hex_to_rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---Sets a global highlight group.
---@param name string @Highlight group name, e.g. "ErrorMsg"
---@param foreground? string @The foreground color
---@param background? string @The background color
---@param italic? boolean
local function set_global_hl(name, foreground, background, italic)
	vim.api.nvim_set_hl(0, name, {
		fg = foreground,
		bg = background,
		italic = italic == true,
	})
end

---Blend foreground with background
---@param foreground string @The foreground color
---@param background string @The background color to blend with
---@param alpha number|string @Number between 0 and 1 for blending amount.
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = hex_to_rgb(background)
	local fg = hex_to_rgb(foreground)

	local blend_channel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
end

---Darken a color by blending it with the background color.
---@param hex string @The color in hex to darken
---@param amount number @The amount to darken the color
---@param bg string @The background color to blend with
---@return string @The darkened color as a hex string
function M.darken(hex, amount, bg)
	return M.blend(hex, bg or "#000000", math.abs(amount))
end

---Lighten a color by blending it with the foreground color.
---@param hex string @The color in hex to lighten
---@param amount number @The amount to lighten the color
---@param fg string @The foreground color to blend with
---@return string @The lightened color as a hex string
function M.lighten(hex, amount, fg)
	return M.blend(hex, fg or "#FFFFFF", math.abs(amount))
end

---Get RGB highlight by highlight group
---@param hl_group string @Highlight group name
---@param use_bg boolean @Returns background or not
---@param fallback_hl? string @Fallback value if the hl group is not defined
---@return string
function M.hl_to_rgb(hl_group, use_bg, fallback_hl)
	local hex = fallback_hl or "#000000"
	local hlexists = pcall(vim.api.nvim_get_hl, 0, { name = hl_group, link = false })

	if hlexists then
		local result = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
		if use_bg then
			hex = result.bg and string.format("#%06x", result.bg) or "NONE"
		else
			hex = result.fg and string.format("#%06x", result.fg) or "NONE"
		end
	end

	return hex
end

---Extend a highlight group
---@param name string @Target highlight group name
---@param def table @Attributes to be extended
function M.extend_hl(name, def)
	local hlexists = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not hlexists then
		-- Do nothing if highlight group not found
		return
	end
	local current_def = vim.api.nvim_get_hl(0, { name = name, link = false })
	local combined_def = vim.tbl_deep_extend("force", current_def, def)

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_set_hl(0, name, combined_def)
end

---Generate universal highlight groups
---@param overwrite palette? @The color to be overwritten | highest priority
---@return palette
function M.get_palette(overwrite)
	if not overwrite then
		return vim.deepcopy(init_palette(), true)
	else
		return vim.tbl_extend("force", init_palette(), overwrite)
	end
end

-- Generate highlight groups for lspsaga. Existing attributes will NOT be overwritten
function M.gen_lspkind_hl()
	local colors = M.get_palette()
	local dat = {
		Class = colors.yellow,
		Constant = colors.peach,
		Constructor = colors.sapphire,
		Enum = colors.yellow,
		EnumMember = colors.teal,
		Event = colors.yellow,
		Field = colors.teal,
		File = colors.rosewater,
		Function = colors.blue,
		Interface = colors.yellow,
		Key = colors.red,
		Method = colors.blue,
		Module = colors.blue,
		Namespace = colors.blue,
		Number = colors.peach,
		Operator = colors.sky,
		Package = colors.blue,
		Property = colors.teal,
		Struct = colors.yellow,
		TypeParameter = colors.blue,
		Variable = colors.peach,
		Array = colors.peach,
		Boolean = colors.peach,
		Null = colors.yellow,
		Object = colors.yellow,
		String = colors.green,
		TypeAlias = colors.green,
		Parameter = colors.blue,
		StaticMethod = colors.peach,
		Text = colors.green,
		Snippet = colors.mauve,
		Folder = colors.blue,
		Unit = colors.green,
		Value = colors.peach,
	}

	for kind, color in pairs(dat) do
		set_global_hl("LspKind" .. kind, color)
	end
end

-- Generate highlight groups for alpha. Existing attributes will NOT be overwritten
function M.gen_alpha_hl()
	local colors = M.get_palette()

	set_global_hl("AlphaHeader", colors.blue)
	set_global_hl("AlphaButtons", colors.green)
	set_global_hl("AlphaShortcut", colors.pink, nil, true)
	set_global_hl("AlphaFooter", colors.yellow)
end

-- Generate highlight groups for cursorword. Existing attributes will NOT be overwritten
function M.gen_cursorword_hl()
	local colors = M.get_palette()

	-- Do not highlight `MiniCursorwordCurrent`
	set_global_hl("MiniCursorword", nil, M.darken(colors.surface1, 0.7, colors.base))
	set_global_hl("MiniCursorwordCurrent", nil)
end

---Setup and enable a language server in one call.
---@param server string @Name of the language server
---@param config? vim.lsp.Config @Optional config to apply
function M.register_server(server, config)
	vim.validate("server", server, "string", false)
	vim.validate("config", config, "table", true)

	if config then
		vim.lsp.config(server, config)
	end
	vim.lsp.enable(server)
end

---Convert number (0/1) to boolean
---@param value number @The value to check
---@return boolean|nil @Returns nil if failed
function M.tobool(value)
	if value == 0 then
		return false
	elseif value == 1 then
		return true
	else
		vim.notify(
			"Attempting to convert data of type '" .. type(value) .. "' [other than 0 or 1] to boolean",
			vim.log.levels.ERROR,
			{ title = "[utils] Runtime Error" }
		)
		return nil
	end
end

--- Function to recursively merge src into dst
--- Unlike vim.tbl_deep_extend(), this function extends if the original value is a list
---@paramm dst table @Table which will be modified and appended to
---@paramm src table @Table from which values will be inserted
---@return table @Modified table
local function tbl_recursive_merge(dst, src)
	for key, value in pairs(src) do
		if type(dst[key]) == "table" and type(value) == "function" then
			dst[key] = value(dst[key])
		elseif type(dst[key]) == "table" and vim.islist(dst[key]) and key ~= "dashboard_image" then
			vim.list_extend(dst[key], value)
		elseif type(dst[key]) == "table" and type(value) == "table" and not vim.islist(dst[key]) then
			tbl_recursive_merge(dst[key], value)
		else
			dst[key] = value
		end
	end
	return dst
end

-- Function to extend existing core configs (settings, events, etc.)
---@param config table @The default config to be merged with
---@param user_config string @The module name used to require user config
---@return table @Extended config
function M.extend_config(config, user_config)
	local ok, extras = pcall(require, user_config)
	if ok and type(extras) == "table" then
		config = tbl_recursive_merge(config, extras)
	end
	return config
end

---@param plugin_name string @Module name of the plugin (used to setup itself)
---@param opts nil|table @The default config to be merged with
---@param vim_plugin? boolean @If this plugin is written in vimscript or not
---@param setup_callback? function @Add new callback if the plugin needs unusual setup function
function M.load_plugin(plugin_name, opts, vim_plugin, setup_callback)
	vim_plugin = vim_plugin or false

	-- Get the file name of the default config
	local fname = debug.getinfo(2, "S").source:match("[^@/\\]*.lua$")
	local ok, user_config = pcall(require, "user.configs." .. fname:sub(0, #fname - 4))
	if ok and vim_plugin then
		if user_config == false then
			-- Return early if the user explicitly requires disabling plugin setup
			return
		elseif type(user_config) == "function" then
			-- OK, setup as instructed by the user
			user_config()
		else
			vim.notify(
				string.format(
					"<%s> is not a typical Lua plugin, please return a function with\nthe corresponding options defined instead (usually via `vim.g.*`)",
					plugin_name
				),
				vim.log.levels.ERROR,
				{ title = "[utils] Runtime Error (User Config)" }
			)
		end
	elseif not vim_plugin then
		if user_config == false then
			-- Return early if the user explicitly requires disabling plugin setup
			return
		else
			setup_callback = setup_callback or require(plugin_name).setup
			-- User config exists?
			if ok then
				-- Extend base config if the returned user config is a table
				if type(user_config) == "table" then
					opts = tbl_recursive_merge(opts, user_config)
					setup_callback(opts)
				-- Replace base config if the returned user config is a function
				elseif type(user_config) == "function" then
					local user_opts = user_config(opts)
					if type(user_opts) == "table" then
						setup_callback(user_opts)
					end
				else
					vim.notify(
						string.format(
							[[
Please return a `table` if you want to override some of the default options OR a
`function` returning a `table` if you want to replace the default options completely.

We received a `%s` for plugin <%s>.]],
							type(user_config),
							plugin_name
						),
						vim.log.levels.ERROR,
						{ title = "[utils] Runtime Error (User Config)" }
					)
				end
			else
				-- Nothing provided... Fallback as default setup of the plugin
				setup_callback(opts)
			end
		end
	end
end

return M
