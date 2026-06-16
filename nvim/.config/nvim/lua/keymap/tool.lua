local vim_path = require("core.global").vim_path
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local helpers = require("keymap.helpers")

local mappings = {
	plugins = {
		-- Plugin: vim-fugitive
		["n|gps"] = map_cr("G push"):with_noremap():with_silent():with_desc("Git: 推送"),
		["n|gpl"] = map_cr("G pull"):with_noremap():with_silent():with_desc("Git: 拉取"),
		["n|<leader>gG"] = map_cu("Git"):with_noremap():with_silent():with_desc("Git: 打开 fugitive"),

		-- Plugin: edgy (file tree)
		["n|<C-n>"] = map_callback(function()
				require("edgy").toggle("left")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("文件树: 切换"),

		-- Plugin: neo-tree
		["n|<leader>nf"] = map_callback(function()
				require("neo-tree.command").execute({ action = "show", reveal = true })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("文件树: 查找文件"),
		["n|<leader>nr"] = map_callback(function()
				require("neo-tree.command").execute({ action = "refresh" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("文件树: 刷新"),

		-- Run current file
		["n|<leader>r"] = map_callback(function()
				helpers.run_current_file()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("运行: 运行当前文件"),

		-- Plugin: toggleterm
		["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(),
		["n|<C-\\>"] = map_cr("ToggleTerm direction=horizontal")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换水平"),
		["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换水平"),
		["t|<C-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换水平"),
		["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换垂直"),
		["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换垂直"),
		["t|<A-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换垂直"),
		["n|<F5>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换垂直"),
		["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换垂直"),
		["t|<F5>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("终端: 切换垂直"),
		-- NOTE: `<A-d>` may conflict with macOS system shortcuts (inserts ∂ in some terminals).
		-- Use `<F5>` (horizontal) or `<A-\\>` (vertical) as alternatives.
		["n|<A-d>"] = map_cr("ToggleTerm direction=float")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换浮动"),
		["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端: 切换浮动"),
		["t|<A-d>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("终端: 切换浮动"),
		["n|<leader>gg"] = map_callback(function()
				helpers.toggle_lazygit()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("Git: 切换 lazygit"),

		-- Plugin: trouble
		["n|gt"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 切换诊断列表"),
		["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 工作区诊断"),
		["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 项目诊断"),
		["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 文档诊断"),

		-- Plugin: snacks picker
		["n|<C-p>"] = map_callback(function()
				require("snacks").picker.keymaps()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 快捷键搜索"),
		["n|<leader>ff"] = map_callback(function()
				local cwd = vim.uv.cwd()
				local opts = cwd == vim_path and { no_ignore = true } or {}
				require("snacks").picker.files(opts)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 查找文件"),
		["n|<leader>fp"] = map_callback(function()
				local cwd = vim.uv.cwd()
				local opts = cwd == vim_path and { no_ignore = true } or {}
				require("snacks").picker.grep(opts)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 搜索内容"),
		["v|<leader>fs"] = map_callback(function()
				require("snacks").picker.grep_word()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 搜索光标下内容"),
		["n|<leader>fg"] = map_callback(function()
				require("snacks").picker.git_files()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: Git 文件"),
		["n|<leader>fd"] = map_callback(function()
				require("snacks").picker.recent()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 最近文件"),
		["n|<leader>fm"] = map_callback(function()
				require("snacks").picker.colorschemes()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 切换主题"),
		["n|<leader>fr"] = map_callback(function()
				require("snacks").picker.resume()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 恢复上次搜索"),

		-- Plugin: dap
		["n|<F6>"] = map_callback(function()
				require("dap").continue()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 运行/继续"),
		["n|<F7>"] = map_callback(function()
				require("dap").terminate()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 停止"),
		["n|<F8>"] = map_callback(function()
				require("dap").toggle_breakpoint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 切换断点"),
		["n|<F9>"] = map_callback(function()
				require("dap").step_into()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 步入"),
		["n|<F10>"] = map_callback(function()
				require("dap").step_out()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 步出"),
		["n|<F11>"] = map_callback(function()
				require("dap").step_over()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 步过"),
		["n|<leader>db"] = map_callback(function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 条件断点"),
		["n|<leader>dc"] = map_callback(function()
				require("dap").run_to_cursor()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 运行到光标"),
		["n|<leader>dl"] = map_callback(function()
				require("dap").run_last()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 重新运行"),
		["n|<leader>do"] = map_callback(function()
				require("dap").repl.open()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 打开 REPL"),
		["n|<leader>dC"] = map_callback(function()
				require("dapui").close()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试: 关闭调试界面"),

		--- Plugin: CodeCompanion and edgy
		["n|<leader>cs"] = map_callback(function()
				helpers.select_chat_model()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 选择 AI 模型"),
		["nv|<leader>cc"] = map_callback(function()
				require("edgy").toggle("right")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具: 切换 AI 聊天"),
		["nv|<leader>ck"] = map_cr("CodeCompanionActions")
			:with_noremap()
			:with_silent()
			:with_desc("工具: AI 操作列表"),
		["v|<leader>ca"] = map_cr("CodeCompanionChat Add")
			:with_noremap()
			:with_silent()
			:with_desc("工具: 添加选中内容到 AI 聊天"),
	},
}

bind.nvim_load_mapping(mappings.plugins)
