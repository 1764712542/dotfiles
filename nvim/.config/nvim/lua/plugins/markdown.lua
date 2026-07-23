-- ==========================================
-- plugins/markdown.lua — Markdown 增强
-- 部署路径: .config/nvim/lua/plugins/markdown.lua
-- 所属包: nvim/
-- 功能: render-markdown.nvim（实时渲染）+ markdown-preview.nvim（浏览器预览）
-- ==========================================
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = { render_modes = { "n", "v" } },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<F12>", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown 预览" },
    },
  },
}
