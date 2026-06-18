return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    keys = {
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "运行文件测试" },
      { "<leader>tN", function() require("neotest").run.run() end, desc = "运行最近测试" },
      { "<leader>tO", function() require("neotest").output.open({ enter = true }) end, desc = "测试输出" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "测试汇总" },
    },
    opts = function()
      local adapters = {}
      local ok_py, py = pcall(require, "neotest-python")
      if ok_py then adapters[#adapters+1] = py({ dap = { justMyCode = false } }) end
      local ok_go, go = pcall(require, "neotest-go")
      if ok_go then adapters[#adapters+1] = go({}) end
      return { adapters = adapters }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
