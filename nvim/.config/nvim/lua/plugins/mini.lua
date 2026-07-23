-- ==========================================
-- plugins/mini.lua — mini.nvim 工具集
-- 部署路径: .config/nvim/lua/plugins/mini.lua
-- 所属包: nvim/
-- 功能: ai（文本对象增强）、surround（环绕编辑）、comment（注释切换）、icons（图标）
-- ==========================================
return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({ n_lines = 50 })
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
      require("mini.icons").setup()
      require("mini.comment").setup()
    end,
  },
}
