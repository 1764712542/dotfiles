local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better escape
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<A-h>", "<C-w><", opts)
map("n", "<A-l>", "<C-w>>", opts)
map("n", "<A-j>", "<C-w>-", opts)
map("n", "<A-k>", "<C-w>+", opts)

-- Tab management
map("n", "<leader>tn", "<cmd>tabnew<CR>", opts)
map("n", "<leader>tc", "<cmd>tabclose<CR>", opts)
map("n", "<leader>th", "<cmd>tabprev<CR>", opts)
map("n", "<leader>tl", "<cmd>tabnext<CR>", opts)

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better paste
map("v", "p", '"_dP', opts)

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Quick save
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)

-- LSP
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>e", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)

-- fzf-lua
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", opts)
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", opts)
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", opts)
map("n", "<leader>f.", "<cmd>FzfLua resume<CR>", opts)

-- Trouble diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", opts)
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", opts)
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", opts)
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", opts)

-- Git
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", opts)
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", opts)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", opts)
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", opts)

-- Oil file explorer
map("n", "<leader>e", "<cmd>Oil<CR>", opts)

-- ToggleTerm
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", opts)
map("t", "<C-\\>", "<cmd>ToggleTerm<CR>", opts)

-- Flash jump
map("n", "s", function() require("flash").jump() end, opts)
map("x", "s", function() require("flash").jump() end, opts)
map("o", "s", function() require("flash").jump() end, opts)
map("n", "S", function() require("flash").treesitter() end, opts)

-- Session persistence
map("n", "<leader>qs", function() require("persistence").load() end, opts)
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, opts)
map("n", "<leader>qd", function() require("persistence").stop() end, opts)

-- Supermaven AI completion
map("i", "<C-y>", function()
  if require("supermaven-nvim").can_accept() then
    require("supermaven-nvim").accept_suggestion()
  end
end, { silent = true })

-- CodeCompanion
map("n", "<leader>ac", "<cmd>CodeCompanion<CR>", opts)
map("v", "<leader>ac", "<cmd>CodeCompanion<CR>", opts)
