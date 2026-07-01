return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = function()
      local icons = require("configs.icons").get_kind()
      return {
        keymap = {
          ["<C-space>"] = { "show", "show_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        appearance = {
          nerd_font_variant = "normal",
          kind_icons = icons,
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
          },
          menu = { border = "rounded" },
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
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
          api_key_name = "OPENROUTER_API_KEY",
          model = "openrouter/free",
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
