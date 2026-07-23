-- ==========================================
-- plugins/im-select.lua — 输入法自动切换
-- 部署路径: .config/nvim/lua/plugins/im-select.lua
-- 所属包: nvim/
-- 功能: 退出插入模式自动切回 ABC 英文输入，避免中文干扰 Vim 模式
-- ==========================================
return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_command = { "im-select" },
      default_im_select = "com.apple.keylayout.ABC",
      set_previous_events = {},
    },
  },
}
