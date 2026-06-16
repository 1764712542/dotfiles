local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_callback = bind.map_callback
local helpers = require("keymap.helpers")

local mappings = {
	fmt = {
		["n|<A-f>"] = map_cr("FormatToggle"):with_noremap():with_silent():with_desc("格式化: 切换保存时格式化"),
		["n|<A-S-f>"] = map_cr("Format"):with_noremap():with_silent():with_desc("格式化: 手动格式化"),
	},
}
bind.nvim_load_mapping(mappings.fmt)

--- The following code allows this file to be exported ---
---    for use with LSP lazy-loaded keymap bindings    ---

local M = {}

---@param buf integer
function M.lsp(buf)
	local map = {
		-- LSP 相关快捷键，仅在有 LSP 附着的缓冲区生效
		["n|<leader>li"] = map_cr("LspInfo"):with_silent():with_buffer(buf):with_desc("LSP: 信息"),
		["n|<leader>lr"] = map_cr("LspRestart"):with_silent():with_buffer(buf):with_nowait():with_desc("LSP: 重启"),
		["n|go"] = map_cr("Trouble symbols toggle win.position=right")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 切换符号大纲"),
		["n|gto"] = map_callback(function()
				helpers.picker("lsp_document_symbols")
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 切换符号大纲（搜索）"),
		["n|g["] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 上一个诊断"),
		["n|g]"] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 下一个诊断"),
		["n|<leader>lx"] = map_callback(function()
				vim.diagnostic.open_float({ border = "rounded" })
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 行内诊断"),
		["n|gs"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end):with_desc("LSP: 签名帮助"),
		["n|gr"] = map_callback(function()
				vim.lsp.buf.rename()
			end)
			:with_silent()
			:with_nowait()
			:with_buffer(buf)
			:with_desc("LSP: 重命名"),
		["n|gR"] = map_callback(function()
				helpers.picker("lsp_references")
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 查找引用"),
		["n|K"] = map_callback(function()
				vim.lsp.buf.hover({ border = "rounded" })
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 显示文档"),
		["nv|ga"] = map_callback(function()
				vim.lsp.buf.code_action()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 代码操作"),
		["n|gd"] = map_callback(function()
				vim.lsp.buf.definition()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 预览定义"),
		["n|gD"] = map_callback(function()
				vim.lsp.buf.definition()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 跳转到定义"),
		["n|gh"] = map_callback(function()
				helpers.picker("lsp_references")
			end)
			:with_noremap()
			:with_nowait()
			:with_silent()
			:with_desc("LSP: 查找引用"),
		["n|gm"] = map_callback(function()
				helpers.picker("lsp_implementations")
			end)
			:with_noremap()
			:with_nowait()
			:with_silent()
			:with_desc("LSP: 查找实现"),
		["n|gci"] = map_callback(function()
				require("snacks").picker.lsp_references()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 传入调用"),
		["n|gco"] = map_callback(function()
				require("snacks").picker.lsp_references()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 传出调用"),
		["n|<leader>lv"] = map_callback(function()
				helpers.toggle_virtuallines()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 切换虚拟行"),
		["n|<leader>lh"] = map_callback(function()
				helpers.toggle_inlayhint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 切换内联提示"),
	}
	bind.nvim_load_mapping(map)

	local ok, user_mappings = pcall(require, "user.keymap.completion")
	if ok and type(user_mappings.lsp) == "function" then
		require("modules.utils.keymap").replace(user_mappings.lsp(buf))
	end
end

return M
