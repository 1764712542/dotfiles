return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "snacks_picker_input", "vim" },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    cmd = "ColorizerToggle",
    opts = {
      "*",
      css = { css_fn = true },
      html = { names = true },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
