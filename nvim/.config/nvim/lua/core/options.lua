local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.termguicolors = true
opt.background = "dark"
opt.hidden = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.timeoutlen = 300
opt.updatetime = 250

opt.clipboard = "unnamedplus"

-- 补全菜单
opt.completeopt = { "menu", "menuone", "noselect" }

-- 滚动
opt.scrolloff = 8
opt.sidescrolloff = 8

-- 行号宽度固定
opt.numberwidth = 4

-- 补全窗口边距
opt.pumheight = 10

-- list chars
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- fillchars
opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = "",
  foldclose = "",
  foldsep = "│",
  vert = "│",
}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- persistence
vim.g.persist_save_on_leave = true

-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.buftype == "" then
      require("persistence").save()
    end
  end,
})
