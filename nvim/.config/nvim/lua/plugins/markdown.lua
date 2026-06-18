return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = { render_modes = { "n", "v" } },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<F12>", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown 预览" },
    },
  },
}
