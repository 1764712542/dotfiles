return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      left = {
        { title = "符号大纲", ft = "trouble", pinned = true, collapsed = false, size = { h = 0.5, w = 0.2 } },
      },
      right = {},
      bottom = {
        { title = "快速修复", ft = "qf", size = { h = 0.3 } },
        { title = "终端", ft = "toggleterm", size = { h = 0.3 } },
        { title = "帮助", ft = "help", size = { h = 0.3 } },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Oil: 文件管理" },
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
    },
  },
}
