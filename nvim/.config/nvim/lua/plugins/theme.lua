-- ==========================================
-- plugins/theme.lua — UI 主题
-- 部署路径: .config/nvim/lua/plugins/theme.lua
-- 所属包: nvim/
-- 功能: tokyonight（配色）、lualine（状态栏）、bufferline（标签栏）、which-key（快捷键引导）
-- ==========================================
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
      sidebars = {
        "trouble",
        "qf",
        "dapui_scaffold",
        "dapui_console",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
      },
      on_highlights = function(hl, c)
        hl.Normal = { fg = c.fg, bg = c.none }
        hl.NormalFloat = { fg = c.fg, bg = c.none }
        hl.FloatBorder = { fg = c.blue, bg = c.none }
        hl.Pmenu = { fg = c.fg_dark, bg = c.none }
        hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
        hl.PmenuBorder = { fg = c.border_highlight, bg = c.none }
        hl.CursorLine = { bg = c.bg_highlight }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
