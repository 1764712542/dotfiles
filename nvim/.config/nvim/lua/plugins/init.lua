return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        comments = { italic = true },
        functions = { bold = true },
        keywords = { italic = true },
        operators = { bold = true },
        conditionals = { bold = true },
        loops = { bold = true },
        booleans = { bold = true, italic = true },
      },
      sidebars = { "neo-tree", "trouble", "qf", "Outline" },
      on_highlights = function(hl, c)
        hl.Normal = { fg = c.fg, bg = c.none }
        hl.NormalFloat = { fg = c.fg, bg = c.none }
        hl.FloatBorder = { fg = c.blue, bg = c.none }
        hl.Pmenu = { fg = c.fg_dark, bg = c.none }
        hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
        hl.PmenuBorder = { fg = c.border_highlight, bg = c.none }
        hl.CursorLine = { bg = c.bg_highlight }
        hl.IblIndent = { fg = c.bg_highlight }
        hl.IblScope = { fg = c.comment, bold = true }

        -- Neon glow Treesitter highlights
        hl["@keyword"] = { fg = "#bb9af7", bold = true }
        hl["@keyword.function"] = { fg = "#bb9af7", bold = true }
        hl["@keyword.conditional"] = { fg = "#7dcfff", bold = true }
        hl["@keyword.repeat"] = { fg = "#7dcfff", bold = true }
        hl["@keyword.import"] = { fg = "#bb9af7", bold = true }
        hl["@keyword.type"] = { fg = "#bb9af7", bold = true }
        hl["@function"] = { fg = "#7dcfff", bold = true }
        hl["@function.call"] = { fg = "#7dcfff", bold = true }
        hl["@function.builtin"] = { fg = "#7dcfff", bold = true }
        hl["@variable"] = { fg = "#c0caf5" }
        hl["@variable.builtin"] = { fg = "#ff9e64", italic = true }
        hl["@variable.parameter"] = { fg = "#ff9e64", italic = true }
        hl["@type"] = { fg = "#e0af68", bold = true }
        hl["@type.builtin"] = { fg = "#e0af68", bold = true }
        hl["@class"] = { fg = "#e0af68", bold = true }
        hl["@string"] = { fg = "#9ece6a" }
        hl["@string.regexp"] = { fg = "#f7768e" }
        hl["@string.escape"] = { fg = "#bb9af7" }
        hl["@number"] = { fg = "#bb9af7" }
        hl["@boolean"] = { fg = "#bb9af7", bold = true, italic = true }
        hl["@operator"] = { fg = "#bb9af7", bold = true }
        hl["@constant"] = { fg = "#ff9e64", bold = true }
        hl["@constant.builtin"] = { fg = "#ff9e64", bold = true }
        hl["@property"] = { fg = "#73daca" }
        hl["@field"] = { fg = "#73daca" }
        hl["@attribute"] = { fg = "#73daca" }
        hl["@comment"] = { fg = "#565f89", italic = true }
        hl["@tag"] = { fg = "#bb9af7", bold = true }
        hl["@tag.attribute"] = { fg = "#73daca" }
        hl["@constructor"] = { fg = "#9ece6a", bold = true }
        hl["@namespace"] = { fg = "#bb9af7", italic = true }
        hl["@label"] = { fg = "#7dcfff" }
        hl["@punctuation.delimiter"] = { fg = "#c0caf5" }
        hl["@punctuation.bracket"] = { fg = "#c0caf5" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("configs.alpha")
    end,
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>fr", desc = "Recent files" },
    },
    opts = {
      "fzf-native",
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          scrollbar = false,
        },
      },
      fzf_opts = {
        ["--border"] = "rounded",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "bash", "c", "go", "lua", "python", "rust", "typescript", "vim", "yaml", "json", "toml", "markdown" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = { "bashls", "gopls", "lua_ls", "pyright", "ruff", "rust_analyzer", "ts_ls" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      local servers = { "bashls", "gopls", "lua_ls", "pyright", "ruff", "rust_analyzer", "ts_ls" }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "CodeCompanion",
    opts = {
      strategies = {
        chat = {
          adapter = "openrouter",
        },
        inline = {
          adapter = "openrouter",
        },
      },
      adapters = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              url = "https://openrouter.ai/api/v1",
              api_key = vim.env.CODE_COMPANION_KEY,
            },
            schema = {
              model = {
                default = "qwen/qwen3-coder:free",
              },
            },
          })
        end,
      },
    },
  },

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.statusline").setup({})
      require("mini.pairs").setup({})
      require("mini.comment").setup({})
      require("mini.icons").setup({})
      require("mini.indentscope").setup({
        symbol = "│",
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
          },
        },
      },
      messages = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
      },
      popupmenu = {
        enabled = false,
      },
    },
  },

  -- ======== Completion Engine ========

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      }
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  -- ======== Git Integration ========

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 500 },
    },
  },

  -- ======== Formatting ========

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        go = { "gofumpt" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        sh = { "shfmt" },
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    },
  },

  -- ======== Diagnostics ========

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "Symbols" },
    },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
