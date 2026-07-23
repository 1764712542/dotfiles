-- ==========================================
-- plugins/snacks.lua — snacks.nvim 全家桶
-- 部署路径: .config/nvim/lua/plugins/snacks.lua
-- 所属包: nvim/
-- 功能: notifier（通知）、indent（缩进线）、scroll（平滑滚动）、terminal（内置终端）、dashboard、picker（模糊搜索）、explorer（文件树）
-- ==========================================
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = false }, -- 用 Yazi 替代
      terminal = { enabled = true },
      dashboard = require("configs.dashboard"),
      indent = {
        enabled = true,
        char = "│",
        scope = { enabled = true, char = "│" },
      },
      animate = { enabled = false },
      scroll = { enabled = false },
      notifier = { enabled = true, timeout = 3000 },
      fold = { enabled = true },
      picker = {
        enabled = true,
        select = { enable = true },
        sources = {
          explorer = { auto_close = false },
        },
        formatters = {
          file = { truncate = 80 },
        },
        win = {
          input = {
            keys = {
              ["<C-j>"] = { "list_down", mode = { "n", "i" } },
              ["<C-k>"] = { "list_up", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
}
