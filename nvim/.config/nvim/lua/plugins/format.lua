-- ==========================================
-- plugins/format.lua — 代码格式化
-- 部署路径: .config/nvim/lua/plugins/format.lua
-- 所属包: nvim/
-- 功能: conform.nvim 自动格式化，保存时触发 + LSP fallback
-- ==========================================
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
        timeout_ms = 1500,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        go = { "gofumpt" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1500 }
      end,
      notify_on_error = true,
    },
  },
}
