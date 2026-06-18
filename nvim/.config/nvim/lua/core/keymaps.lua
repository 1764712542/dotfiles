local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "" }
local function keymap(mode, lhs, rhs, desc)
  map(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
end

-- ======== 插入模式 ========
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)

-- ======== 窗口导航 (smart-splits) ========
keymap("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, "左窗口")
keymap("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, "下窗口")
keymap("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, "上窗口")
keymap("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, "右窗口")
keymap("n", "<A-h>", function() require("smart-splits").resize_left() end, "缩小")
keymap("n", "<A-j>", function() require("smart-splits").resize_down() end, "缩小")
keymap("n", "<A-k>", function() require("smart-splits").resize_up() end, "放大")
keymap("n", "<A-l>", function() require("smart-splits").resize_right() end, "放大")
keymap("n", "<leader>Wh", function() require("smart-splits").move_cursor_left() end, "窗口左移")
keymap("n", "<leader>Wj", function() require("smart-splits").move_cursor_down() end, "窗口下移")
keymap("n", "<leader>Wk", function() require("smart-splits").move_cursor_up() end, "窗口上移")
keymap("n", "<leader>Wl", function() require("smart-splits").move_cursor_right() end, "窗口右移")

-- ======== 搜索 (snacks.picker) ========
keymap("n", "<leader>ff", function() Snacks.picker.files() end, "查找文件")
keymap("n", "<leader>fg", function() Snacks.picker.grep() end, "全文搜索")
keymap("n", "<leader>fb", function() Snacks.picker.buffers() end, "缓冲区")
keymap("n", "<leader>fh", function() Snacks.picker.help() end, "帮助标签")
keymap("n", "<leader>fr", function() Snacks.picker.resume() end, "恢复搜索")
keymap("n", "<leader>fp", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, "当前目录文件")
keymap("n", "<leader>f.", function() Snacks.picker.recent() end, "最近文件")
keymap("n", "<C-p>", function() Snacks.picker.keymaps() end, "命令面板")

-- ======== 文件树 (snacks.explorer) ========
keymap("n", "<leader>n", function() require("snacks").explorer() end, "文件树")

-- ======== 标签页 (term: <leader>t) ========
keymap("n", "<leader>tn", "<cmd>tabnew<CR>", "新建标签")
keymap("n", "<leader>th", "<cmd>tabprev<CR>", "左标签")
keymap("n", "<leader>tl", "<cmd>tabnext<CR>", "右标签")
keymap("n", "<leader>tc", "<cmd>tabclose<CR>", "关闭标签")
keymap("n", "<leader>to", "<cmd>tabonly<CR>", "只留当前")
keymap("n", "<leader>t1", "<cmd>tabn 1<CR>", "标签 1")
keymap("n", "<leader>t2", "<cmd>tabn 2<CR>", "标签 2")
keymap("n", "<leader>t3", "<cmd>tabn 3<CR>", "标签 3")
keymap("n", "<leader>t4", "<cmd>tabn 4<CR>", "标签 4")
keymap("n", "<leader>t5", "<cmd>tabn 5<CR>", "标签 5")
keymap("n", "<leader>t6", "<cmd>tabn 6<CR>", "标签 6")
keymap("n", "<leader>t7", "<cmd>tabn 7<CR>", "标签 7")
keymap("n", "<leader>t8", "<cmd>tabn 8<CR>", "标签 8")
keymap("n", "<leader>t9", "<cmd>tabn 9<CR>", "标签 9")

-- ======== Buffer 导航 ========
keymap("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", "下一个 Buffer")
keymap("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", "上一个 Buffer")
keymap("n", "<A-i>", "<cmd>BufferLineCycleNext<CR>", "下一个 Buffer")
keymap("n", "<A-o>", "<cmd>BufferLineCyclePrev<CR>", "上一个 Buffer")
keymap("n", "<A-q>", "<cmd>BufDel<CR>", "关闭 Buffer")
keymap("n", "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", "Buffer 1")
keymap("n", "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", "Buffer 2")
keymap("n", "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", "Buffer 3")
keymap("n", "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", "Buffer 4")
keymap("n", "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", "Buffer 5")
keymap("n", "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", "Buffer 6")
keymap("n", "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>", "Buffer 7")
keymap("n", "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>", "Buffer 8")
keymap("n", "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>", "Buffer 9")
keymap("n", "<A-S-i>", "<cmd>BufferLineMoveNext<CR>", "Buffer 右移")
keymap("n", "<A-S-o>", "<cmd>BufferLineMovePrev<CR>", "Buffer 左移")
keymap("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", "下一个 Buffer")
keymap("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", "上一个 Buffer")
keymap("n", "<leader>bd", "<cmd>BufDel<CR>", "关闭 Buffer")

-- ======== 编辑器 ========
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", "清除搜索高亮")
keymap("n", "<leader>rr", "<cmd>redraw!<CR>", "屏幕重绘")
map("v", "p", function()
  if vim.bo.modifiable then vim.cmd('normal! "_dP') end
end, { noremap = true, silent = true, desc = "粘贴不丢失" })
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap("n", "Y", "y$", "复制到行尾")
keymap("n", "n", "nzzzv", "下一个")
keymap("n", "N", "Nzzzv", "上一个")

-- ======== 包管理 (lazy.nvim) ========
keymap("n", "<leader>ph", "<cmd>Lazy<CR>", "包管理: 面板")
keymap("n", "<leader>ps", "<cmd>Lazy sync<CR>", "包管理: 同步")
keymap("n", "<leader>pu", "<cmd>Lazy update<CR>", "包管理: 更新")
keymap("n", "<leader>pi", "<cmd>Lazy install<CR>", "包管理: 安装")
keymap("n", "<leader>pl", "<cmd>Lazy log<CR>", "包管理: 日志")
keymap("n", "<leader>pc", "<cmd>Lazy check<CR>", "包管理: 检查")
keymap("n", "<leader>pp", "<cmd>Lazy profile<CR>", "包管理: 性能")
keymap("n", "<leader>pr", "<cmd>Lazy restore<CR>", "包管理: 恢复")
keymap("n", "<leader>px", "<cmd>Lazy clean<CR>", "包管理: 清理")

-- ======== 保存 / 退出 ========
keymap({ "n", "i" }, "<C-s>", "<cmd>w<CR>", "保存")
keymap("n", "<leader>q", "<cmd>q<CR>", "退出")
keymap("n", "<leader>Q", "<cmd>qa<CR>", "全部退出")

-- ======== 终端 ========
map("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
keymap({ "n", "i" }, "<A-d>", "<cmd>ToggleTerm direction=float<CR>", "浮动终端")

-- ======== 格式化 ========
keymap("n", "<A-f>", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("格式保存: " .. (vim.g.disable_autoformat and "关" or "开"))
end, "切换格式保存")
keymap("n", "<A-S-f>", function()
  require("conform").format()
end, "手动格式化")

-- ======== AI (Avante) ========
keymap("n", "<leader>aa", function() require("avante.api").ask() end, "Avante 对话")
keymap("n", "<leader>am", function() require("avante.api").select_model() end, "选择模型")
keymap("n", "<leader>at", function() require("avante.api").toggle() end, "切换侧边栏")
keymap("n", "<leader>as", function()
  local cur = require("avante.config").provider
  local next = cur == "fast" and "strong" or "fast"
  require("avante.api").switch_provider(next)
  vim.notify("Avante 切换: " .. next)
end, "切换模型")
keymap("v", "<leader>ae", function() require("avante.api").edit() end, "编辑选区")

-- ======== 运行代码 (终端底部面板) ========
keymap("n", "<leader>r", function()
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
    rust = function()
      local cargo = vim.fn.findfile("Cargo.toml", ".;")
      if cargo ~= "" then
        return "cargo run --manifest-path " .. cargo
      end
      return "cargo run"
    end,
    javascript = "node " .. filename,
    typescript = "node " .. filename,
    bash = "bash " .. filename,
    sh = "bash " .. filename,
    c = "gcc " .. filename .. " -o /tmp/a.out && /tmp/a.out",
    cpp = "g++ " .. filename .. " -o /tmp/a.out && /tmp/a.out",
  }
  local cmd_raw = cmd_map[ft]
  if not cmd_raw then
    vim.notify("不支持运行 " .. ft .. " 文件", vim.log.levels.WARN)
    return
  end
  local cmd = type(cmd_raw) == "function" and cmd_raw() or cmd_raw
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
end, "运行代码")

-- ======== 调试 (DAP) ========
keymap("n", "<F6>", function() require("dap").continue() end, "继续")
keymap("n", "<F7>", function() require("dap").terminate() end, "停止")
keymap("n", "<F8>", function() require("dap").toggle_breakpoint() end, "断点")
keymap("n", "<F9>", function() require("dap").step_into() end, "步入")
keymap("n", "<F10>", function() require("dap").step_over() end, "步过")
keymap("n", "<F11>", function() require("dap").step_out() end, "步出")
keymap("n", "<leader>dc", function() require("dap").continue() end, "继续")
keymap("n", "<leader>db", function() require("dap").toggle_breakpoint() end, "断点切换")
keymap("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("条件: ")) end, "条件断点")
keymap("n", "<leader>do", function() require("dap").step_over() end, "单步跳过")
keymap("n", "<leader>di", function() require("dap").step_into() end, "单步进入")
keymap("n", "<leader>dO", function() require("dap").step_out() end, "单步跳出")
keymap("n", "<leader>dt", function() require("dap").terminate() end, "终止调试")
keymap("n", "<leader>dr", function() require("dapui").toggle() end, "调试界面")
