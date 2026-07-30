-- ==========================================
-- plugins/explorer.lua — 侧边栏布局
-- 部署路径: .config/nvim/lua/plugins/explorer.lua
-- 所属包: nvim/
-- 功能: edgy.nvim（侧边栏布局）
-- ==========================================
return {
  {
    "folke/edgy.nvim",
    event = "WinNew",
    opts = {
      left = {
        { title = "符号大纲", ft = "trouble", pinned = true, collapsed = false, size = { h = 0.5, w = 0.2 } },
      },
      right = {},
      bottom = {
        { title = "快速修复", ft = "qf", size = { h = 0.3 } },
        { title = "终端", ft = "snacks_terminal", size = { h = 0.3 } },
        { title = "帮助", ft = "help", size = { h = 0.3 } },
      },
    },
  },
}
