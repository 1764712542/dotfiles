-- ==========================================
-- plugins/treesitter.lua — Treesitter 解析器
-- 部署路径: .config/nvim/lua/plugins/treesitter.lua
-- 所属包: nvim/
-- 功能: 语法树高亮、增量解析、结构化文本对象（function/class/block 选择与移动）
-- ==========================================
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      parsers = {
        "bash",
        "c",
        "go",
        "lua",
        "python",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "json",
        "toml",
        "markdown",
        "html",
        "css",
        "javascript",
        "java",
        "cpp",
        "sql",
      },
    },
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      treesitter.install(opts.parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = opts.parsers,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
            ["@block.outer"] = "V",
          },
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local map = vim.keymap.set

      map({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end, { desc = "函数外层" })
      map({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end, { desc = "函数内层" })
      map({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end, { desc = "类外层" })
      map({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end, { desc = "类内层" })
      map({ "x", "o" }, "ab", function()
        select.select_textobject("@block.outer", "textobjects")
      end, { desc = "块外层" })
      map({ "x", "o" }, "ib", function()
        select.select_textobject("@block.inner", "textobjects")
      end, { desc = "块内层" })
      map("n", "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "下个函数" })
      map("n", "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "上个函数" })
      map("n", "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "下个类" })
      map("n", "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "上个类" })
      map("n", "]a", function()
        move.goto_next_start("@parameter.outer", "textobjects")
      end, { desc = "下个参数" })
      map("n", "[a", function()
        move.goto_previous_start("@parameter.outer", "textobjects")
      end, { desc = "上个参数" })
      map("n", "<leader>an", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "参数后移" })
      map("n", "<leader>ap", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "参数前移" })
    end,
  },
}
