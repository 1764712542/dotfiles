return {
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
}
