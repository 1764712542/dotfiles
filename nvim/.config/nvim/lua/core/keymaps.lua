local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "" }

-- ======== 插入模式 ========
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)

-- ======== 窗口导航 (smart-splits) ========
map("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, vim.tbl_extend("force", opts, { desc = "左窗口" }))
map("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, vim.tbl_extend("force", opts, { desc = "下窗口" }))
map("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, vim.tbl_extend("force", opts, { desc = "上窗口" }))
map("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, vim.tbl_extend("force", opts, { desc = "右窗口" }))
map("n", "<A-h>", function() require("smart-splits").resize_left() end, vim.tbl_extend("force", opts, { desc = "缩小" }))
map("n", "<A-j>", function() require("smart-splits").resize_down() end, vim.tbl_extend("force", opts, { desc = "缩小" }))
map("n", "<A-k>", function() require("smart-splits").resize_up() end, vim.tbl_extend("force", opts, { desc = "放大" }))
map("n", "<A-l>", function() require("smart-splits").resize_right() end, vim.tbl_extend("force", opts, { desc = "放大" }))

-- ======== 标签页 (无前缀) ========
map("n", "tn", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "新建标签" }))
map("n", "tj", "<cmd>tabprev<CR>", vim.tbl_extend("force", opts, { desc = "上个标签" }))
map("n", "tk", "<cmd>tabnext<CR>", vim.tbl_extend("force", opts, { desc = "下个标签" }))
map("n", "to", "<cmd>tabonly<CR>", vim.tbl_extend("force", opts, { desc = "只留当前" }))

-- ======== Buffer 导航 ========
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))
map("n", "<A-i>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<A-o>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))
map("n", "<A-q>", "<cmd>BufDel<CR>", vim.tbl_extend("force", opts, { desc = "关闭 Buffer" }))
map("n", "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 1" }))
map("n", "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 2" }))
map("n", "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 3" }))
map("n", "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 4" }))
map("n", "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 5" }))
map("n", "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 6" }))
map("n", "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 7" }))
map("n", "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 8" }))
map("n", "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 9" }))
map("n", "<A-S-i>", "<cmd>BufferLineMoveNext<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 右移" }))
map("n", "<A-S-o>", "<cmd>BufferLineMovePrev<CR>", vim.tbl_extend("force", opts, { desc = "Buffer 左移" }))
map("n", "<leader>bb", function() require("telescope.builtin").buffers() end, vim.tbl_extend("force", opts, { desc = "Buffer 列表" }))
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "下一个 Buffer" }))
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "上一个 Buffer" }))
map("n", "<leader>bd", "<cmd>BufDel<CR>", vim.tbl_extend("force", opts, { desc = "关闭 Buffer" }))

-- ======== 编辑器 ========
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "清除搜索高亮" }))
map("v", "p", '"_dP', opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("n", "Y", "y$", vim.tbl_extend("force", opts, { desc = "复制到行尾" }))
map("n", "n", "nzzzv", vim.tbl_extend("force", opts, { desc = "下一个" }))
map("n", "N", "Nzzzv", vim.tbl_extend("force", opts, { desc = "上一个" }))

-- ======== 包管理 (lazy.nvim) ========
map("n", "<leader>ph", "<cmd>Lazy<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 面板" }))
map("n", "<leader>ps", "<cmd>Lazy sync<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 同步" }))
map("n", "<leader>pu", "<cmd>Lazy update<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 更新" }))
map("n", "<leader>pi", "<cmd>Lazy install<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 安装" }))
map("n", "<leader>pl", "<cmd>Lazy log<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 日志" }))
map("n", "<leader>pc", "<cmd>Lazy check<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 检查" }))
map("n", "<leader>pp", "<cmd>Lazy profile<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 性能" }))
map("n", "<leader>pr", "<cmd>Lazy restore<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 恢复" }))
map("n", "<leader>px", "<cmd>Lazy clean<CR>", vim.tbl_extend("force", opts, { desc = "包管理: 清理" }))

-- ======== 保存 / 退出 ========
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "保存" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "退出" }))
map("n", "<leader>Q", "<cmd>qa<CR>", vim.tbl_extend("force", opts, { desc = "全部退出" }))

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
  require("conform").setup({ format_on_save = vim.g.format_on_save and { lsp_format = "fallback", timeout_ms = 500 } or nil })
end, vim.tbl_extend("force", opts, { desc = "切换格式保存" }))
map("n", "<A-S-f>", function()
  require("conform").format()
end, vim.tbl_extend("force", opts, { desc = "手动格式化" }))

-- ======== AI 补全 (Supermaven) ========
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
map("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", vim.tbl_extend("force", opts, { desc = "AI 聊天" }))
map({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanion<CR>", vim.tbl_extend("force", opts, { desc = "AI 内联" }))

-- ======== AI 聊天: 添加当前文件到上下文 ========
map("n", "<leader>ca", function()
  local cc = require("codecompanion")
  local chat = cc.last_chat()
  if chat then
    chat:add_buf_message({
      role = "user",
      content = "Here is the current file:\n```"
        .. vim.bo.filetype
        .. "\n"
        .. table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        .. "\n```\n",
    })
    vim.notify("已添加当前文件到聊天上下文")
  else
    vim.notify("没有打开的聊天窗口，请先打开 <leader>cc")
  end
end, vim.tbl_extend("force", opts, { desc = "添加文件到上下文" }))

-- ======== 运行代码 (终端底部面板) ========
map("n", "<leader>r", function()
  vim.cmd("silent! write")
  local ft = vim.bo.filetype
  local filename = vim.fn.expand("%:p")
  if filename == "" then
    vim.notify("请先保存文件", vim.log.levels.WARN)
    return
  end
  local cmd_map = {
    python = "python3 " .. filename,
    lua = "lua " .. filename,
    go = "go run " .. filename,
    rust = "cargo run",
    javascript = "node " .. filename,
    typescript = "node " .. filename,
    bash = "bash " .. filename,
    sh = "bash " .. filename,
    c = "gcc " .. filename .. " -o /tmp/a.out && /tmp/a.out",
    cpp = "g++ " .. filename .. " -o /tmp/a.out && /tmp/a.out",
  }
  local cmd = cmd_map[ft]
  if not cmd then
    vim.notify("不支持运行 " .. ft .. " 文件", vim.log.levels.WARN)
    return
  end
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, { split = "below", height = 12 })
  vim.bo[buf].filetype = "toggleterm"
  vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = buf, noremap = true })
  vim.keymap.set("n", "q", "<cmd>close!<CR>", { buffer = buf, noremap = true, silent = true })
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.schedule(function()
        vim.notify("运行完毕，按 q / <Esc><Esc> 关闭面板")
      end)
    end,
  })
  vim.cmd("startinsert")
end, vim.tbl_extend("force", opts, { desc = "运行代码" }))

-- ======== 调试 (DAP) ========
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
