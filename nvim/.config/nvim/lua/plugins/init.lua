return {
  -- ======== Theme ========
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
      sidebars = { "trouble", "qf", "dapui_scaffold", "dapui_console", "dapui_watches", "dapui_stacks", "dapui_breakpoints" },
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
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ======== Icons ========
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ======== Statusline (lualine) ========
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "branch", icon = "" }, { "diff", symbols = { added = " ", modified = " ", removed = " " } } },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = " [No Name]" } },
        },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          { "filetype" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ======== Bufferline (tab bar) ========
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        indicator = { icon = "▎", style = "icon" },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warn = " ", info = " " }
          local ret = ""
          for _, d in ipairs(diag) do
            local icon = icons[d[1]] or ""
            if d[2] > 0 then ret = ret .. icon .. d[2] .. " " end
          end
          return ret
        end,
        offsets = { { filetype = "NvimTree", text = "文件树", text_align = "left" } },
      },
    },
  },
  {
    "ojroques/nvim-bufdel",
    keys = {
      { "<A-q>", "<cmd>BufDel<CR>", desc = "关闭 Buffer" },
    },
    opts = { next = "tabs" },
  },

  -- ======== Dialogs (dressing) ========
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = true, default_prompt = " ", border = "rounded" },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = { border = "rounded" },
      },
    },
  },

  -- ======== Indent guides ========
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = { smart_indent_cap = true, priority = 1 },
      whitespace = { highlight = "IblWhitespace", remove_blankline_trail = false },
      scope = { show_start = false, show_end = false, highlight = "IblScope" },
    },
    config = function(_, opts)
      local ibl = require("ibl")
      ibl.setup(opts)
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "tokyonight",
        callback = function()
          vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2c3e50" })
          vim.api.nvim_set_hl(0, "IblScope", { fg = "#565f89", bold = true })
        end,
      })
    end,
  },

  -- ======== Cmdline UI (noice) ========
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = { position = { row = "50%", col = "50%" }, size = { width = "auto", height = "auto" } },
      },
      messages = { enabled = false },
      notify = { enabled = false },
      lsp = { progress = { enabled = false } },
      popupmenu = { enabled = false },
    },
  },

  -- ======== Autopairs ========
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  -- ======== Color preview ========
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    cmd = "ColorizerToggle",
    opts = {
      "*",
      css = { css_fn = true },
      html = { names = true },
    },
  },

  -- ======== Comment ========
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ======== Dashboard ========
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("configs.alpha")
    end,
  },

  -- ======== Search (telescope) ========
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "查找文件" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "全文搜索" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "缓冲区" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "帮助标签" },
      { "<leader>fr", function() require("telescope.builtin").resume() end, desc = "恢复搜索" },
      { "<leader>fp", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "当前目录文件" },
      { "<leader>f.", function() require("telescope.builtin").oldfiles() end, desc = "最近文件" },
      { "<C-p>", function() require("telescope.builtin").keymaps() end, desc = "命令面板" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = { "--hidden", "--no-ignore" } },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
          undo = {},
          live_grep_args = { auto_quoting = true },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "undo")
      pcall(require("telescope").load_extension, "live_grep_args")
    end,
  },

  -- ======== Treesitter + Textobjects ========
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = {
        "bash", "c", "go", "lua", "python", "rust", "typescript",
        "vim", "yaml", "json", "toml", "markdown", "html", "css",
        "javascript", "java", "cpp", "sql",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>an"] = "@parameter.inner" },
          swap_previous = { ["<leader>ap"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)
    end,
  },

  -- ======== LSP ========
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = { "bashls", "gopls", "lua_ls", "pyright", "ruff", "rust_analyzer", "ts_ls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "跳转定义" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "跳转声明" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "悬浮文档" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "查找实现" }))
        vim.keymap.set("n", "gh", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "查找引用" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "重命名" }))
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "代码操作" }))
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "签名帮助" }))
        vim.keymap.set("n", "go", "<cmd>Trouble symbols toggle win.position=right<CR>", vim.tbl_extend("force", bufopts, { desc = "符号大纲" }))
        vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, vim.tbl_extend("force", bufopts, { desc = "上个诊断" }))
        vim.keymap.set("n", "g]", vim.diagnostic.goto_next, vim.tbl_extend("force", bufopts, { desc = "下个诊断" }))

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      local servers = { "bashls", "gopls", "pyright", "ruff", "rust_analyzer", "ts_ls", "lua_ls" }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },

  -- ======== Completion ========
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
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
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
  { "rafamadriz/friendly-snippets", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },

  -- ======== AI (CodeCompanion + Supermaven) ========
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat" },
    opts = {
      strategies = {
        chat = {
          adapter = "openrouter",
          window = {
            layout = "vertical",
            position = "right",
            width = 0.3,
          },
          tools = {
            opts = { default_tools = { "agent" } },
          },
        },
        inline = { adapter = "openrouter" },
      },
      adapters = {
        http = {
          openrouter = function()
            return require("codecompanion.adapters").extend("openai", {
              url = "https://openrouter.ai/api/v1/chat/completions",
              env = {
                api_key = "CODE_COMPANION_KEY",
              },
              schema = { model = { default = "openrouter/free" } },
            })
          end,
        },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = nil,
        clear_suggestion = nil,
        accept_word = nil,
        accept_line = nil,
      },
      log_level = "warn",
    },
  },

  -- ======== Window Management (smart-splits) ========
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      at_end = "stop",
      cursor_follows_win = true,
    },
  },

  -- ======== Split/Join Code (treesj) ========
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>m", "<cmd>TSJToggle<CR>", desc = "拆分/合并代码" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },

  -- ======== Search & Replace (grug-far) ========
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>Sr", "<cmd>GrugFar<CR>", desc = "搜索替换" },
      { "<leader>Sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "替换当前词" },
    },
    opts = {
      border = "rounded",
      engine = "ripgrep",
      startInInsertMode = true,
    },
  },

  -- ======== Git ========
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "]g", function() require("gitsigns").nav_hunk("next") end, desc = "下个 Hunk" },
      { "[g", function() require("gitsigns").nav_hunk("prev") end, desc = "上个 Hunk" },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "暂存 Hunk", mode = { "n", "v" } },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "重置 Hunk", mode = { "n", "v" } },
      { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "重置缓冲区" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "预览 Hunk" },
      { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame" },
      { "<leader>gB", function() require("gitsigns").toggle_current_line_blame() end, desc = "切换行号 Blame" },
    },
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
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git Diff" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "关闭 Diff" },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Gstatus" },
    keys = {
      { "<leader>gG", "<cmd>Git<CR>", desc = "Git 面板" },
      { "gps", "<cmd>G push<CR>", desc = "Git Push" },
      { "gpl", "<cmd>G pull<CR>", desc = "Git Pull" },
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
      notify_on_error = false,
    },
  },

  -- ======== Diagnostics ========
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "gt", "<cmd>Trouble diagnostics toggle<CR>", desc = "全部诊断" },
      { "<leader>lw", "<cmd>Trouble diagnostics toggle<CR>", desc = "诊断列表" },
      { "<leader>lp", "<cmd>Trouble project_diagnostics toggle<CR>", desc = "项目诊断" },
      { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "当前诊断" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "符号列表" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "位置列表" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "快速修复" },
    },
    opts = {
      focus = true,
      multiline = true,
      pinned = false,
      warn_no_results = true,
      open_no_result = true,
      win = {
        position = "right",
        size = 0.3,
        type = "split",
      },
    },
  },

  -- ======== File Explorer (nvim-tree + edgy) ========
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeRefresh" },
    keys = {
      { "<leader>nf", "<cmd>NvimTreeFindFile<CR>", desc = "定位文件" },
      { "<leader>nr", "<cmd>NvimTreeRefresh<CR>", desc = "刷新文件树" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      auto_reload_on_write = true,
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = { enable = true },
      },
      view = { width = 35 },
      renderer = {
        indent_width = 2,
        icons = {
          show = { file = true, folder = true, git = true },
          glyphs = {
            default = "",
            symlink = "",
            folder = { arrow_closed = "", arrow_open = "", default = "", open = "" },
            git = { unstaged = "", staged = "", unmerged = "󰘬", renamed = "", untracked = "★", deleted = "", ignored = "◌" },
          },
        },
      },
      filters = { dotfiles = false, custom = { ".DS_Store" } },
      actions = { open_file = { quit_on_open = false, resize_window = true } },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      left = {
        { title = "文件树", ft = "NvimTree", pinned = true, collapsed = false, size = { h = 0.5, w = 0.2 } },
        { title = "符号大纲", ft = "trouble", pinned = true, collapsed = false, size = { h = 0.5, w = 0.2 },
          open = function()
            if vim.bo.buftype == "" then return "Trouble symbols toggle win.position=right" end
          end },
      },
      right = {
        { title = "AI 聊天", ft = "codecompanion", size = { w = 0.25 } },
      },
      bottom = {
        { title = "快速修复", ft = "qf", size = { h = 0.3 } },
        { title = "终端", ft = "toggleterm", size = { h = 0.3 } },
        { title = "帮助", ft = "help", size = { h = 0.3 } },
      },
    },
  },

  -- ======== Floating Terminal ========
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "切换终端", mode = { "n", "t" } },
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "切换终端" },
    },
    opts = {
      size = 12,
      open_mapping = nil,
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },

  -- ======== Quick Cursor Jump (hop + flash) ========
  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>w", function() require("hop").hint_words() end, desc = "跳转单词" },
      { "<leader>j", function()
        local Hint = require("hop.hint")
        require("hop").hint_lines({ direction = Hint.HintDirection.AFTER_CURSOR })
      end, desc = "跳转下行" },
      { "<leader>k", function()
        local Hint = require("hop.hint")
        require("hop").hint_lines({ direction = Hint.HintDirection.BEFORE_CURSOR })
      end, desc = "跳转上行" },
      { "<leader>C", function() require("hop").hint_char2() end, desc = "跳转双字符" },
    },
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    config = function(_, opts)
      require("hop").setup(opts)
      -- Override hop default highlights to match Tokyo Night color scheme
      vim.api.nvim_set_hl(0, "HopNextKey",  { fg = "#ff9e64", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey1", { fg = "#7dcfff", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey2", { fg = "#2b8db3" })
      vim.api.nvim_set_hl(0, "HopUnmatched", { fg = "#565f89" })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "快速跳转" },
      { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "语法跳转" },
    },
    opts = { modes = { char = { enabled = false } } },
  },

  -- ======== Session Persistence (persisted.nvim) ========
  {
    "olimorris/persisted.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>ss", function() require("persisted").save() end, desc = "保存会话" },
      { "<leader>sl", function() require("persisted").load() end, desc = "加载会话" },
      { "<leader>sd", function() require("persisted").delete() end, desc = "删除会话" },
    },
  },

  -- ======== TODO Highlight ========
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- ======== Visual Undo ========
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "撤销历史" },
    },
  },

  -- ======== Debugger (DAP) ========
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dap-python").setup("python3")
      require("dap-go").setup({
        delve = { path = "dlv" },
      })

      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        layouts = {
          { elements = { { id = "scopes", size = 0.50 }, { id = "stacks", size = 0.25 }, { id = "watches", size = 0.25 } }, position = "right", size = 40 },
          { elements = { { id = "repl", size = 0.75 }, { id = "console", size = 0.25 } }, position = "bottom", size = 15 },
        },
        floating = { max_height = 0.8, max_width = 0.7, border = "rounded" },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        virt_text_pos = "eol",
        highlight_changed_variables = true,
        all_frames = true,
      })
    end,
  },

  -- ======== Markdown ========
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = { render_modes = { "n", "v" } },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<F12>", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown 预览" },
    },
  },

  -- ======== Which-key ========
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("configs.icons")
      return {
        spec = {
          { "<leader>f", group = icons.ui.Search .. " 搜索" },
          { "<leader>s", group = icons.ui.History .. " 会话" },
          { "<leader>b", group = icons.ui.Buffer .. " Buffer" },
          { "<leader>c", group = icons.aichat.Chat .. " AI 聊天" },
          { "<leader>d", group = icons.ui.Bug .. " 调试" },
          { "<leader>g", group = icons.git.Git .. " Git" },
          { "<leader>l", group = icons.misc.LspAvailable .. " LSP" },
          { "<leader>n", group = icons.ui.FolderOpen .. " 文件树" },
          { "<leader>p", group = icons.ui.Package .. " 包管理" },
          { "<leader>t", group = icons.ui.Keyboard .. " 终端" },
          { "<leader>W", group = icons.ui.Window .. " 窗口" },
          { "<leader>S", group = icons.ui.Search .. " 搜索替换" },
          { "<leader>u", group = icons.ui.History .. " 撤销" },
          { "<leader>x", group = icons.diagnostics.Error .. " 诊断" },
        },
      }
    end,
  },
}
