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
      auto_suggestions_provider = "fast",
      providers = {
        fast = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key = "OPENROUTER_API_KEY",
          api_key_name = "OPENROUTER_API_KEY",
          model = "openrouter/owl-alpha",
        },
        strong = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key = "OPENROUTER_API_KEY",
          api_key_name = "OPENROUTER_API_KEY",
          model = "openrouter/owl-alpha",
        },
      },
      suggestion = {
        debounce = 600,
        throttle = 300,
      },
      mappings = {
        suggestion = {
          accept = "<C-y>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      behaviour = {
        auto_set_keymaps = false,
        auto_suggestions = true,
        auto_add_current_file = true,
      },
    },
  },
}
