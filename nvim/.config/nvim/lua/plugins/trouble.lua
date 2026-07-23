return {
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
}
