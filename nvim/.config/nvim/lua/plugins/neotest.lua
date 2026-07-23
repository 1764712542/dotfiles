-- ==========================================
-- plugins/neotest.lua — 测试运行器
-- 部署路径: .config/nvim/lua/plugins/neotest.lua
-- 所属包: nvim/
-- 功能: neotest 测试框架（支持多种语言适配器）
-- ==========================================
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    keys = {
      {
        "<leader>ntf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "运行文件测试",
      },
      {
        "<leader>ntn",
        function()
          require("neotest").run.run()
        end,
        desc = "运行当前测试",
      },
      {
        "<leader>ntl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "重复上次测试",
      },
      {
        "<leader>ntd",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "调试当前测试",
      },
      {
        "<leader>nto",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "测试输出",
      },
      {
        "<leader>nts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "测试汇总",
      },
    },
    opts = function()
      local adapters = {}
      local ok_py, py = pcall(require, "neotest-python")
      if ok_py then
        adapters[#adapters + 1] = py({ dap = { justMyCode = false } })
      end
      local ok_go, go = pcall(require, "neotest-go")
      if ok_go then
        adapters[#adapters + 1] = go({})
      end
      return { adapters = adapters }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
