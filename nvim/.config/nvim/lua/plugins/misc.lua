-- ==========================================
-- plugins/misc.lua — 杂项插件
-- 部署路径: .config/nvim/lua/plugins/misc.lua
-- 所属包: nvim/
-- 功能: blink.pairs（括号自动补全）、todo-comments（TODO/FIXME 高亮）、undotree、grug-far
-- ==========================================
return {
  {
    "saghen/blink.pairs",
    version = "*",
    event = "InsertEnter",
    dependencies = "saghen/blink.lib",
    build = function()
      require("blink.pairs").download():pwait(60000)
    end,
    opts = {
      mappings = {
        disabled_filetypes = { "snacks_picker_input", "vim" },
      },
      highlights = {
        matchparen = {
          include_surrounding = true,
        },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "xml" },
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = {
      "*",
      css = { css_fn = true },
      html = { names = true },
    },
  },
}
