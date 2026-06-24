return {
  {
    "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {
      provider = "fast",
      providers = {
        fast = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key = "OPENROUTER_API_KEY",
          api_key_name = "OPENROUTER_API_KEY",
          model = "openrouter/owl-alpha",
        },
      },
      behaviour = {
        auto_set_keymaps = false,
        auto_suggestions = false,
        auto_add_current_file = true,
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
    },
  },
}
