return {
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
      { "<leader>gP", "<cmd>G push<CR>", desc = "Git Push" },
      { "<leader>gl", "<cmd>G pull<CR>", desc = "Git Pull" },
    },
  },
}
