return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "切换终端", mode = { "n", "i", "t" } },
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "切换终端" },
    },
    opts = {
      size = 12,
      open_mapping = nil,
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "快速跳转" },
      { "<leader>k", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "语法跳转" },
    },
    opts = { modes = { char = { enabled = false } } },
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      at_end = "stop",
      cursor_follows_win = true,
    },
  },
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
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "撤销历史" },
    },
  },
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
}
