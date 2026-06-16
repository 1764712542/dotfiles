local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "" }

-- 退出插入模式
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)

-- 窗口导航
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- 窗口大小
map("n", "<A-h>", "<C-w><", opts)
map("n", "<A-l>", "<C-w>>", opts)
map("n", "<A-j>", "<C-w>-", opts)
map("n", "<A-k>", "<C-w>+", opts)

-- 标签页
map("n", "<leader>tn", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "新建标签" }))
map("n", "<leader>tc", "<cmd>tabclose<CR>", vim.tbl_extend("force", opts, { desc = "关闭标签" }))
map("n", "<leader>th", "<cmd>tabprev<CR>", vim.tbl_extend("force", opts, { desc = "上个标签" }))
map("n", "<leader>tl", "<cmd>tabnext<CR>", vim.tbl_extend("force", opts, { desc = "下个标签" }))

-- 清除搜索高亮
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- 粘贴增强
map("v", "p", '"_dP', opts)

-- 移动行
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 保存 / 退出
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "退出" }))

-- ======== LSP 操作 ========

map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "跳转定义" }))
map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "跳转声明" }))
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "悬浮文档" }))
map("n", "<leader>lr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "查找引用" }))
map("n", "<leader>li", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "查找实现" }))
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "代码操作" }))
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "重命名" }))

-- 诊断
map("n", "<leader>de", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "诊断详情" }))
map("n", "<leader>d[", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "上个诊断" }))
map("n", "<leader>d]", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "下个诊断" }))

-- ======== 文件搜索 (fzf-lua) ========

map("n", "<leader>ff", "<cmd>FzfLua files<CR>", vim.tbl_extend("force", opts, { desc = "搜索文件" }))
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", vim.tbl_extend("force", opts, { desc = "全文搜索" }))
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", vim.tbl_extend("force", opts, { desc = "缓冲区列表" }))
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", vim.tbl_extend("force", opts, { desc = "帮助文档" }))
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", vim.tbl_extend("force", opts, { desc = "最近文件" }))
map("n", "<leader>f.", "<cmd>FzfLua resume<CR>", vim.tbl_extend("force", opts, { desc = "上次结果" }))

-- ======== 诊断面板 (Trouble) ========

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", vim.tbl_extend("force", opts, { desc = "全部诊断" }))
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", vim.tbl_extend("force", opts, { desc = "当前诊断" }))
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", vim.tbl_extend("force", opts, { desc = "位置列表" }))
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", vim.tbl_extend("force", opts, { desc = "快速修复" }))

-- ======== Git ========

map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", vim.tbl_extend("force", opts, { desc = "代码作者" }))
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", vim.tbl_extend("force", opts, { desc = "预览改动" }))
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", vim.tbl_extend("force", opts, { desc = "暂存块" }))
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", vim.tbl_extend("force", opts, { desc = "撤销块" }))

-- ======== 文件管理器 (Oil) ========

map("n", "<leader>e", "<cmd>Oil<CR>", vim.tbl_extend("force", opts, { desc = "文件管理器" }))

-- ======== 终端 ========

map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", vim.tbl_extend("force", opts, { desc = "切换终端" }))
map("t", "<C-\\>", "<cmd>ToggleTerm<CR>", vim.tbl_extend("force", opts, { desc = "切换终端" }))

-- ======== 快速跳转 (Flash) ========

map("n", "<leader>s", function() require("flash").jump() end, vim.tbl_extend("force", opts, { desc = "快速跳转" }))
map("x", "<leader>s", function() require("flash").jump() end, vim.tbl_extend("force", opts, { desc = "快速跳转" }))
map("o", "<leader>s", function() require("flash").jump() end, vim.tbl_extend("force", opts, { desc = "快速跳转" }))
map("n", "<leader>S", function() require("flash").treesitter() end, vim.tbl_extend("force", opts, { desc = "语法跳转" }))

-- ======== 会话管理 ========

map("n", "<leader>qs", function() require("persistence").load() end, vim.tbl_extend("force", opts, { desc = "恢复会话" }))
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, vim.tbl_extend("force", opts, { desc = "上次会话" }))
map("n", "<leader>qd", function() require("persistence").stop() end, vim.tbl_extend("force", opts, { desc = "停止会话" }))

-- ======== 运行代码 ========

map("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local run_cmd = nil
  if ft == "python" then
    run_cmd = "python3 " .. vim.fn.expand("%")
  elseif ft == "lua" then
    run_cmd = "lua " .. vim.fn.expand("%")
  elseif ft == "go" then
    run_cmd = "go run " .. vim.fn.expand("%")
  elseif ft == "rust" then
    run_cmd = "cargo run"
  elseif ft == "javascript" or ft == "typescript" then
    run_cmd = "node " .. vim.fn.expand("%")
  elseif ft == "bash" or ft == "sh" then
    run_cmd = "bash " .. vim.fn.expand("%")
  elseif ft == "c" then
    run_cmd = "gcc " .. vim.fn.expand("%") .. " && ./a.out"
  elseif ft == "cpp" then
    run_cmd = "g++ " .. vim.fn.expand("%") .. " && ./a.out"
  else
    vim.notify("不支持运行 " .. ft .. " 文件", vim.log.levels.WARN)
    return
  end
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({ cmd = run_cmd, direction = "float" })
  term:toggle()
end, vim.tbl_extend("force", opts, { desc = "运行代码" }))

-- ======== AI 补全 (Supermaven) ========

map("i", "<C-y>", function()
  if require("supermaven-nvim").can_accept() then
    require("supermaven-nvim").accept_suggestion()
  end
end, { silent = true, desc = "接受 AI 补全" })

-- ======== AI 聊天 (CodeCompanion) ========

map("n", "<leader>ac", "<cmd>CodeCompanion<CR>", vim.tbl_extend("force", opts, { desc = "AI 聊天" }))
map("v", "<leader>ac", "<cmd>CodeCompanion<CR>", vim.tbl_extend("force", opts, { desc = "AI 聊天" }))
