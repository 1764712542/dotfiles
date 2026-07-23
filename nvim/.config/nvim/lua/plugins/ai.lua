-- ==========================================
-- plugins/ai.lua — AI 插件（Avante + blink.cmp）
-- 部署路径: .config/nvim/lua/plugins/ai.lua
-- 所属包: nvim/
-- 功能: AI 对话补全及内联编辑，通过 Zen Proxy 路由到 DeepSeek V4 Flash
-- ==========================================
return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
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
    "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AvanteAsk", "AvanteChat", "AvanteEdit", "AvanteToggle" },
    opts = {
      provider = "zen",
      providers = {
        zen = {
          __inherited_from = "openai",
          endpoint = "http://127.0.0.1:8123/v1",
          model = "deepseek-v4-flash-free",
          api_key_name = "",
        },
      },
      behaviour = {
        auto_set_keymaps = false,
        auto_suggestions = false,
        auto_add_current_file = true,
      },
    },
  },
}
