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

-- Buffer 导航
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))
map("n", "<leader>bd", "<cmd>bd<CR>", vim.tbl_extend("force", opts, { desc = "关闭 Buffer" }))
map("n", "<leader>bD", "<cmd>bd!<CR>", vim.tbl_extend("force", opts, { desc = "强制关闭 Buffer" }))

-- 清除搜索高亮
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "清除搜索高亮" }))

-- 粘贴增强（不覆盖寄存器）
map("v", "p", '"_dP', opts)

-- 移动行
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 保存 / 退出
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "退出" }))
map("n", "<leader>Q", "<cmd>qa<CR>", vim.tbl_extend("force", opts, { desc = "全部退出" }))

-- ======== 编辑器 ========
-- 新行而不进入插入模式
map("n", "<leader>o", "o<Esc>", vim.tbl_extend("force", opts, { desc = "下方新建行" }))
map("n", "<leader>O", "O<Esc>", vim.tbl_extend("force", opts, { desc = "上方新建行" }))

-- ======== AI 补全 (Supermaven) ========
map("i", "<C-y>", function()
  if require("supermaven-nvim").can_accept() then
    require("supermaven-nvim").accept_suggestion()
  end
end, { silent = true, desc = "接受 AI 补全" })

-- ======== AI 聊天 (CodeCompanion) ========
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanion<CR>", vim.tbl_extend("force", opts, { desc = "AI 聊天" }))

-- ======== 运行代码 ========
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

-- ======== 调试 (DAP) ========
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "断点切换" }))
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("条件: ")) end, vim.tbl_extend("force", opts, { desc = "条件断点" }))
map("n", "<leader>dc", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "继续运行" }))
map("n", "<leader>do", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "单步跳过" }))
map("n", "<leader>di", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "单步进入" }))
map("n", "<leader>dO", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "单步跳出" }))
map("n", "<leader>dt", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "终止调试" }))
map("n", "<leader>dr", function() require("dapui").toggle() end, vim.tbl_extend("force", opts, { desc = "调试界面" }))
