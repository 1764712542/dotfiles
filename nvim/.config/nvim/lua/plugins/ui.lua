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
        offsets = {},
      },
    },
  },
  {
    "ojroques/nvim-bufdel",
    opts = { next = "tabs" },
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
          { "<leader>t", group = icons.ui.Tab .. " 标签页" },
          { "<leader>W", group = icons.ui.Window .. " 窗口" },
          { "<leader>S", group = icons.ui.Search .. " 搜索替换" },
          { "<leader>x", group = icons.diagnostics.Error .. " 诊断" },
        },
      }
    end,
  },
}
