local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "" }

-- ======== 插入模式 ========
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)
map("i", "<C-s>", "<Esc>:w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)

-- ======== 窗口导航 (smart-splits) ========
map("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, vim.tbl_extend("force", opts, { desc = "左窗口" }))
map("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, vim.tbl_extend("force", opts, { desc = "下窗口" }))
map("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, vim.tbl_extend("force", opts, { desc = "上窗口" }))
map("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, vim.tbl_extend("force", opts, { desc = "右窗口" }))
map("n", "<A-h>", function() require("smart-splits").resize_left() end, vim.tbl_extend("force", opts, { desc = "缩小" }))
map("n", "<A-l>", function() require("smart-splits").resize_right() end, vim.tbl_extend("force", opts, { desc = "放大" }))
map("n", "<A-j>", function() require("smart-splits").resize_down() end, vim.tbl_extend("force", opts, { desc = "缩小" }))
map("n", "<A-k>", function() require("smart-splits").resize_up() end, vim.tbl_extend("force", opts, { desc = "放大" }))

-- 标签页 (无前缀, 保持与 nvimdots 一致)
map("n", "tn", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "新建标签" }))
map("n", "tk", "<cmd>tabnext<CR>", vim.tbl_extend("force", opts, { desc = "下个标签" }))
map("n", "tj", "<cmd>tabprev<CR>", vim.tbl_extend("force", opts, { desc = "上个标签" }))
map("n", "to", "<cmd>tabonly<CR>", vim.tbl_extend("force", opts, { desc = "只留当前" }))
map("n", "<leader>tn", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "新建标签" }))
map("n", "<leader>tc", "<cmd>tabclose<CR>", vim.tbl_extend("force", opts, { desc = "关闭标签" }))

-- Buffer 导航 (bufferline)
map("n", "<A-i>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<A-o>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))
map("n", "<A-q>", "<cmd>bd<CR>", vim.tbl_extend("force", opts, { desc = "关闭 Buffer" }))
map("n", "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 1" }))
map("n", "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 2" }))
map("n", "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 3" }))
map("n", "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 4" }))
map("n", "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 5" }))
map("n", "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 6" }))
map("n", "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 7" }))
map("n", "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 8" }))
map("n", "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 9" }))
map("n", "<leader>bd", "<cmd>bd<CR>", vim.tbl_extend("force", opts, { desc = "关闭 Buffer" }))
map("n", "<leader>bD", "<cmd>bd!<CR>", vim.tbl_extend("force", opts, { desc = "强制关闭" }))
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))

-- 编辑器
map("n", "<C-s>", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "清除搜索高亮" }))
map("v", "p", '"_dP', opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("n", "Y", "y$", vim.tbl_extend("force", opts, { desc = "复制到行尾" }))
map("n", "n", "nzzzv", vim.tbl_extend("force", opts, { desc = "下一个" }))
map("n", "N", "Nzzzv", vim.tbl_extend("force", opts, { desc = "上一个" }))
map("n", "<leader>o", "o<Esc>", vim.tbl_extend("force", opts, { desc = "下方新建行" }))
map("n", "<leader>O", "O<Esc>", vim.tbl_extend("force", opts, { desc = "上方新建行" }))

-- 保存 / 退出
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "退出" }))
map("n", "<leader>Q", "<cmd>qa<CR>", vim.tbl_extend("force", opts, { desc = "全部退出" }))

-- LSP 快捷 (非 buffer-local, 用于全局 fallback)
map("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "签名帮助" }))

-- ======== LSP 诊断导航 ========
map("n", "g[", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "上个诊断" }))
map("n", "g]", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "下个诊断" }))
map("n", "<leader>de", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "诊断详情" }))

-- ======== 终端 ========
map("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
map("t", "<C-\\>", "<cmd>ToggleTerm<CR>", opts)
map({ "n", "i" }, "<C-\\>", "<cmd>ToggleTerm direction=horizontal<CR>", opts)
map({ "n", "i" }, "<A-d>", "<cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", opts, { desc = "浮动终端" }))
map("n", "<F5>", "<cmd>ToggleTerm direction=vertical<CR>", vim.tbl_extend("force", opts, { desc = "终端" }))
map("i", "<F5>", "<Esc><cmd>ToggleTerm direction=vertical<CR>", opts)
map("t", "<F5>", "<cmd>ToggleTerm<CR>", opts)

-- ======== 格式化 ========
map("n", "<A-f>", function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify("格式保存: " .. (vim.g.format_on_save and "开" or "关"))
end, vim.tbl_extend("force", opts, { desc = "切换格式保存" }))
map("n", "<A-S-f>", function()
  require("conform").format()
end, vim.tbl_extend("force", opts, { desc = "手动格式化" }))

-- ======== AI 补全 (Supermaven) ========
-- C-j 部分接受 (accept_word), C-l 全部接受 (accept_suggestion)
map("i", "<C-j>", function()
  if require("supermaven-nvim").can_accept() then
    require("supermaven-nvim").accept_word()
  end
end, { silent = true, desc = "AI 补全: 部分接受" })
map("i", "<C-l>", function()
  if require("supermaven-nvim").can_accept() then
    require("supermaven-nvim").accept_suggestion()
  end
end, { silent = true, desc = "AI 补全: 全部接受" })

-- ======== AI 聊天 (CodeCompanion) ========
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanion<CR>", vim.tbl_extend("force", opts, { desc = "AI 聊天" }))

-- ======== 运行代码 (浮动窗口) ========
map("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local cmd = nil
  if ft == "python" then
    cmd = "python3 " .. vim.fn.expand("%")
  elseif ft == "lua" then
    cmd = "lua " .. vim.fn.expand("%")
  elseif ft == "go" then
    cmd = "go run " .. vim.fn.expand("%")
  elseif ft == "rust" then
    cmd = "cargo run"
  elseif ft == "javascript" or ft == "typescript" then
    cmd = "node " .. vim.fn.expand("%")
  elseif ft == "bash" or ft == "sh" then
    cmd = "bash " .. vim.fn.expand("%")
  elseif ft == "c" then
    cmd = "gcc " .. vim.fn.expand("%") .. " && ./a.out"
  elseif ft == "cpp" then
    cmd = "g++ " .. vim.fn.expand("%") .. " && ./a.out"
  else
    vim.notify("不支持运行 " .. ft .. " 文件", vim.log.levels.WARN)
    return
  end
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({ cmd = cmd, direction = "float" })
  term:toggle()
end, vim.tbl_extend("force", opts, { desc = "运行代码" }))

-- ======== 调试 (DAP) - F 键 + Leader 键 ========
map("n", "<F6>", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "继续" }))
map("n", "<F7>", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "停止" }))
map("n", "<F8>", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "断点" }))
map("n", "<F9>", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "步入" }))
map("n", "<F10>", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "步过" }))
map("n", "<F11>", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "步出" }))

map("n", "<leader>dc", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "继续" }))
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "断点切换" }))
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("条件: ")) end, vim.tbl_extend("force", opts, { desc = "条件断点" }))
map("n", "<leader>do", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "单步跳过" }))
map("n", "<leader>di", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "单步进入" }))
map("n", "<leader>dO", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "单步跳出" }))
map("n", "<leader>dt", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "终止调试" }))
map("n", "<leader>dr", function() require("dapui").toggle() end, vim.tbl_extend("force", opts, { desc = "调试界面" }))
