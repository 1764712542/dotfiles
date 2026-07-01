return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "y",
        clear_suggestion = "l",
        accept_word = "j",
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
