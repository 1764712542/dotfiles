return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      cursor_color = "#FF69B4",
      stiffness = 0.6,
      trailing_stiffness = 0.45,
      damping = 0.85,
    },
    config = function(_, opts)
      require("smear_cursor").setup(opts)
      vim.api.nvim_set_hl(0, "Cursor", { bg = "#FF69B4", fg = "#1a1b26" })
    end,
  },
}
