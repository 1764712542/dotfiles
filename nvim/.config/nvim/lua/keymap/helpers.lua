local M = {}

M.flash_esc_or_noh = function()
	local flash_active, state = pcall(function()
		return require("flash.plugins.char").state
	end)
	if flash_active and state then
		state:hide()
	else
		pcall(vim.cmd.noh)
	end
end

M.picker = function(method, _)
	---@type table<string, fun(opts?: table)>
	local map = {
		lsp_references = function()
			require("snacks").picker.lsp_references()
		end,
		lsp_implementations = function()
			require("snacks").picker.lsp_implementations()
		end,
		lsp_document_symbols = function()
			require("snacks").picker.lsp_symbols()
		end,
	}
	local fn = map[method]
	if fn then
		fn()
	end
end

M.toggle_inlayhint = function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not is_enabled)
	vim.notify(
		(is_enabled and "内联提示已禁用" or "内联提示已启用"),
		vim.log.levels.INFO,
		{ title = "LSP 内联提示" }
	)
end

M.toggle_virtuallines = function()
	require("tiny-inline-diagnostic").toggle()
	vim.notify(
		"虚拟行已"
			.. (require("tiny-inline-diagnostic.diagnostic").user_toggle_state and "显示" or "隐藏"),
		vim.log.levels.INFO,
		{ title = "LSP 诊断" }
	)
end

M.run_current_file = function()
	local filetype = vim.bo.filetype
	local filename = vim.fn.expand("%")
	local cmd

	local runners = {
		python = "python3 ",
		go = "go run ",
		rust = "cargo run",
		javascript = "node ",
		typescript = "node --loader ts-node/esm ",
		lua = "lua ",
		sh = "bash ",
		zsh = "zsh ",
		c = function()
			local out = vim.fn.tempname()
			return "gcc " .. filename .. " -o " .. out .. " && " .. out
		end,
		cpp = function()
			local out = vim.fn.tempname()
			return "g++ " .. filename .. " -o " .. out .. " && " .. out
		end,
	}

	local runner = runners[filetype]
	if not runner then
		vim.notify("不支持的文件类型: " .. filetype, vim.log.levels.WARN, { title = "运行代码" })
		return
	end

	if type(runner) == "function" then
		cmd = runner()
	else
		cmd = runner .. filename
	end

	vim.cmd("ToggleTerm direction=float")
	vim.schedule(function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd .. "<CR>", true, false, true), "n", false)
	end)
end

local _lazygit = nil
M.toggle_lazygit = function()
	if vim.fn.executable("lazygit") == 1 then
		if not _lazygit then
			_lazygit = require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = "float",
				close_on_exit = true,
				hidden = true,
			})
		end
		_lazygit:toggle()
	else
		vim.notify("未找到命令 [lazygit]！", vim.log.levels.ERROR, { title = "toggleterm.nvim" })
	end
end

M.select_chat_model = function()
	local models = require("core.settings").chat_models
	require("snacks").picker.select(models, {
		prompt = "选择 AI 模型",
		format_item = function(item)
			return item
		end,
	}, function(item)
		if item then
			vim.g.current_chat_model = item
			vim.notify("已选择模型: " .. item, vim.log.levels.INFO, { title = "CodeCompanion" })
		end
	end)
end

return M
