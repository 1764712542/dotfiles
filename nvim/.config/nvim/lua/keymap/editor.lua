---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode
local helpers = require("keymap.helpers")

local ts_to_select = require("nvim-treesitter-textobjects.select")
local ts_to_swap = require("nvim-treesitter-textobjects.swap")
local ts_to_move = require("nvim-treesitter-textobjects.move")
local ts_to_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

local mappings = {
	builtins = {
		-- Builtins: Save & Quit
		["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("编辑: 保存"),
		["n|<C-q>"] = map_cr("wq"):with_desc("编辑: 保存并退出"),
		["n|<A-S-q>"] = map_cr("q!"):with_desc("编辑: 强制退出"),

		-- Builtins: Insert mode
		["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("编辑: 删除前一块"),
		["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑: 光标左移"),
		["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("编辑: 光标移动到行首"),
		["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("编辑: 保存"),
		["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("编辑: 保存并退出"),

		-- Builtins: Command mode
		["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑: 左移"),
		["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("编辑: 右移"),
		["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("编辑: 行首"),
		["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("编辑: 行尾"),
		["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("编辑: 删除"),
		["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("编辑: 退格"),
		["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
			:with_noremap()
			:with_desc("编辑: 补全当前文件路径"),

		-- Builtins: Visual mode
		["v|J"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("编辑: 向下移动选中行"),
		["v|K"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("编辑: 向上移动选中行"),
		["v|<"] = map_cmd("<gv"):with_desc("编辑: 减少缩进"),
		["v|>"] = map_cmd(">gv"):with_desc("编辑: 增加缩进"),

		-- Builtins: "Suckless" - named after r/suckless
		["n|Y"] = map_cmd("y$"):with_desc("编辑: 复制到行尾"),
		["n|D"] = map_cmd("d$"):with_desc("编辑: 删除到行尾"),
		["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("编辑: 下一个搜索结果"),
		["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("编辑: 上一个搜索结果"),
		["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("编辑: 合并下一行"),
		["n|<S-Tab>"] = map_cr("normal za"):with_noremap():with_silent():with_desc("编辑: 切换代码折叠"),
		["n|<Esc>"] = map_callback(function()
				helpers.flash_esc_or_noh()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("编辑: 清除搜索高亮"),
		["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("编辑: 切换拼写检查"),
	},
	plugins = {
		-- Plugin: persisted.nvim
		["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("会话: 保存"),
		["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("会话: 加载"),
		["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("会话: 删除"),

		-- Plugin: comment.nvim
		["n|gcc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
					or et("<Plug>(comment_toggle_linewise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑: 切换行注释"),
		["n|gbc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
					or et("<Plug>(comment_toggle_blockwise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑: 切换块注释"),
		["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 行注释（操作符）"),
		["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 块注释（操作符）"),
		["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 行注释（选中）"),
		["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 块注释（选中）"),

		-- Plugin: diffview.nvim
		["n|<leader>gd"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("Git: 显示差异"),
		["n|<leader>gD"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("Git: 关闭差异"),

		-- Plugin: flash.nvim (replaces hop.nvim)
		["nv|<leader>w"] = map_callback(function()
				require("flash").jump()
			end)
			:with_noremap()
			:with_desc("跳转: 跳转到单词"),
		["nv|<leader>j"] = map_callback(function()
				require("flash").jump({
					labels = require("flash.config").config.label,
					pattern = "^",
				})
			end)
			:with_noremap()
			:with_desc("跳转: 跳转到行"),
		["nv|<leader>k"] = map_callback(function()
				require("flash").jump({
					pattern = "^",
				})
			end)
			:with_noremap()
			:with_desc("跳转: 跳转到行"),
		["nv|<leader>c"] = map_callback(function()
				require("flash").jump()
			end)
			:with_noremap()
			:with_desc("跳转: 跳转到字符"),
		["nv|<leader>C"] = map_callback(function()
				require("flash").treesitter()
			end)
			:with_noremap()
			:with_desc("跳转: 跳转到语法符号"),

		-- Plugin: grug-far
		["n|<leader>Ss"] = map_callback(function()
				require("grug-far").open()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 打开搜索替换面板"),
		["n|<leader>Sp"] = map_callback(function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前词（项目）"),
		["v|<leader>Sp"] = map_callback(function()
				require("grug-far").with_visual_selection()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前词（项目）"),
		["n|<leader>Sf"] = map_callback(function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前词（文件）"),

		-- Plugin: suda.vim
		["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("编辑: 用 sudo 保存"),

		-- Plugin: nvim-treesitter-textobjects
		-- Text objects: select
		["xo|af"] = map_callback(function()
				ts_to_select.select_textobject("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择函数外部"),
		["xo|if"] = map_callback(function()
				ts_to_select.select_textobject("@function.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择函数内部"),
		["xo|ac"] = map_callback(function()
				ts_to_select.select_textobject("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择类外部"),
		["xo|ic"] = map_callback(function()
				ts_to_select.select_textobject("@class.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择类内部"),
		-- Text objects: swap
		["n|<leader>a"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.inner")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 交换下一个参数"),
		["n|<leader>A"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.outer")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 交换上一个参数"),
		-- Text objects: move
		["nxo|]["] = map_callback(function()
				ts_to_move.goto_next_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 下一个函数开头"),
		["nxo|]m"] = map_callback(function()
				ts_to_move.goto_next_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 下一个类开头"),
		["nxo|]]"] = map_callback(function()
				ts_to_move.goto_next_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 下一个函数结尾"),
		["nxo|]M"] = map_callback(function()
				ts_to_move.goto_next_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 下一个类结尾"),
		["nxo|[["] = map_callback(function()
				ts_to_move.goto_previous_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 上一个函数开头"),
		["nxo|[m"] = map_callback(function()
				ts_to_move.goto_previous_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 上一个类开头"),
		["nxo|[]"] = map_callback(function()
				ts_to_move.goto_previous_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 上一个函数结尾"),
		["nxo|[M"] = map_callback(function()
				ts_to_move.goto_previous_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 上一个类结尾"),
		-- movements repeat
		["nxo|;"] = map_callback(function()
				ts_to_repeat_move.repeat_last_move_next()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 重复上次移动"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)
