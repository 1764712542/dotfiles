-- ==========================================
-- plugins/ui.lua — UI 增强
-- 部署路径: .config/nvim/lua/plugins/ui.lua
-- 所属包: nvim/
-- 功能: lualine.nvim（状态栏）、bufferline.nvim（标签栏）、dressing.nvim/noice.nvim/which-key.nvim（界面增强）
-- ==========================================
return {
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
        disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = "" },
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = " [No Name]" } },
          {
            function()
              local ok, loc = pcall(require("nvim-navic").get_location)
              return ok and loc or ""
            end,
            cond = function()
              local ok, navic = pcall(require, "nvim-navic")
              return ok and navic.is_available()
            end,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          { "filetype" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
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
            if d[2] > 0 then
              ret = ret .. icon .. d[2] .. " "
            end
          end
          return ret
        end,
        offsets = {},
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = true, default_prompt = " ", border = "rounded" },
      select = {
        enabled = true,
        backend = { "builtin" },
        builtin = { border = "rounded" },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = { border = "rounded", position = { row = "50%", col = "50%" } },
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      lsp = {
        progress = { enabled = false },
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines",
          "vim.lsp.util.stylify_markdown",
          "vim.lsp.util.open_floating_preview",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },
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
          { "<leader>a", group = icons.aichat.Chat .. " AI Agent" },
          { "<leader>d", group = icons.ui.Bug .. " 调试" },
          { "<leader>g", group = icons.git.Git .. " Git" },
          { "<leader>l", group = icons.misc.LspAvailable .. " LSP" },
          { "<leader>p", group = icons.ui.Package .. " 包管理" },
          { "<leader>nt", group = icons.ui.List .. " 测试" },
          { "<leader>r", group = icons.ui.Play .. " 运行" },
          { "<leader>t", group = icons.ui.Tab .. " 标签页" },
          { "<leader>W", group = icons.ui.Window .. " 窗口" },
          { "<leader>S", group = icons.ui.Search .. " 搜索替换" },
          { "<leader>x", group = icons.diagnostics.Error .. " 诊断" },
        },
      }
    end,
  },
}
