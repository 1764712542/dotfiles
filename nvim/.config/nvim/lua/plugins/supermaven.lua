-- ==========================================
-- plugins/supermaven.lua — AI 行内补全
-- 部署路径: .config/nvim/lua/plugins/supermaven.lua
-- 所属包: nvim/
-- 功能: Supermaven 免费版 AI 行内补全（支持单词级接受 y/j/l）
-- ==========================================
return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-l>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = {
        markdown = true,
        help = true,
        oil = true,
      },
    },
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)
    end,
  },
}
