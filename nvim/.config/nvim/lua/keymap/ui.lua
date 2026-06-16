local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local mappings = {
	builtins = {
		-- Builtins: Buffer
		["n|<leader>bn"] = map_cu("enew"):with_noremap():with_silent():with_desc("缓冲区: 新建"),

		-- Builtins: Terminal
		["t|<C-w>h"] = map_cmd("<Cmd>wincmd h<CR>"):with_silent():with_noremap():with_desc("窗口: 焦点左移"),
		["t|<C-w>l"] = map_cmd("<Cmd>wincmd l<CR>"):with_silent():with_noremap():with_desc("窗口: 焦点右移"),
		["t|<C-w>j"] = map_cmd("<Cmd>wincmd j<CR>"):with_silent():with_noremap():with_desc("窗口: 焦点下移"),
		["t|<C-w>k"] = map_cmd("<Cmd>wincmd k<CR>"):with_silent():with_noremap():with_desc("窗口: 焦点上移"),

		-- Builtins: Tabpage
		["n|tn"] = map_cr("tabnew"):with_noremap():with_silent():with_desc("标签: 新建"),
		["n|tk"] = map_cr("tabnext"):with_noremap():with_silent():with_desc("标签: 下一个"),
		["n|tj"] = map_cr("tabprevious"):with_noremap():with_silent():with_desc("标签: 上一个"),
		["n|to"] = map_cr("tabonly"):with_noremap():with_silent():with_desc("标签: 只保留当前"),
	},
	plugins = {
		["n|<A-q>"] = map_cu("bd"):with_noremap():with_silent():with_desc("缓冲区: 关闭当前"),

		-- Plugin: bufferline.nvim
		["n|<A-i>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("缓冲区: 切换到下一个"),
		["n|<A-o>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("缓冲区: 切换到上一个"),
		["n|<A-S-i>"] = map_cr("BufferLineMoveNext")
			:with_noremap()
			:with_silent()
			:with_desc("缓冲区: 右移当前"),
		["n|<A-S-o>"] = map_cr("BufferLineMovePrev")
			:with_noremap()
			:with_silent()
			:with_desc("缓冲区: 左移当前"),
		["n|<leader>be"] = map_cr("BufferLineSortByExtension"):with_noremap():with_desc("缓冲区: 按扩展名排序"),
		["n|<leader>bd"] = map_cr("BufferLineSortByDirectory"):with_noremap():with_desc("缓冲区: 按目录排序"),
		["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 1"),
		["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 2"),
		["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 3"),
		["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 4"),
		["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 5"),
		["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 6"),
		["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 7"),
		["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 8"),
		["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9"):with_noremap():with_silent():with_desc("缓冲区: 跳转到 9"),

		-- Plugin: smart-splits.nvim
		["n|<A-h>"] = map_cu("SmartResizeLeft")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 宽度减小"),
		["n|<A-j>"] = map_cu("SmartResizeDown"):with_silent():with_noremap():with_desc("窗口: 高度减小"),
		["n|<A-k>"] = map_cu("SmartResizeUp"):with_silent():with_noremap():with_desc("窗口: 高度增加"),
		["n|<A-l>"] = map_cu("SmartResizeRight")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 宽度增加"),
		["n|<C-h>"] = map_cu("SmartCursorMoveLeft"):with_silent():with_noremap():with_desc("窗口: 焦点左移"),
		["n|<C-j>"] = map_cu("SmartCursorMoveDown"):with_silent():with_noremap():with_desc("窗口: 焦点下移"),
		["n|<C-k>"] = map_cu("SmartCursorMoveUp"):with_silent():with_noremap():with_desc("窗口: 焦点上移"),
		["n|<C-l>"] = map_cu("SmartCursorMoveRight"):with_silent():with_noremap():with_desc("窗口: 焦点右移"),
		["n|<leader>Wh"] = map_cu("SmartSwapLeft")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 左移窗口"),
		["n|<leader>Wj"] = map_cu("SmartSwapDown")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 下移窗口"),
		["n|<leader>Wk"] = map_cu("SmartSwapUp"):with_silent():with_noremap():with_desc("窗口: 上移窗口"),
		["n|<leader>Wl"] = map_cu("SmartSwapRight")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 右移窗口"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)

--- The following code enables this file to be exported ---
---  for use with gitsigns lazy-loaded keymap bindings  ---

local M = {}

function M.gitsigns(bufnr)
	local gitsigns = require("gitsigns")
	local map = {
		["n|]g"] = map_callback(function()
				if vim.wo.diff then
					return "]g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("next")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("Git: 下一个修改块"),
		["n|[g"] = map_callback(function()
				if vim.wo.diff then
					return "[g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("prev")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("Git: 上一个修改块"),
		["n|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 暂存/取消暂存修改块"),
		["v|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 暂存选中的修改块"),
		["n|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 撤销修改块"),
		["v|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 撤销选中的修改块"),
		["n|<leader>gR"] = map_callback(function()
				gitsigns.reset_buffer()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 撤销缓冲区修改"),
		["n|<leader>gp"] = map_callback(function()
				gitsigns.preview_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 预览修改块"),
		["n|<leader>gb"] = map_callback(function()
				gitsigns.blame_line({ full = true })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 代码行溯源"),
		-- Text objects
		["ox|ih"] = map_callback(function()
				gitsigns.select_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap(),
	}
	bind.nvim_load_mapping(map)
end

return M
