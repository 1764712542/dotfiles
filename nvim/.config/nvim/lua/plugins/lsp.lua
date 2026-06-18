-- Neovim >= 0.11 required for vim.lsp.config / vim.lsp.enable API
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.notify("LSP config requires Neovim >= 0.11", vim.log.levels.ERROR)
  return {}
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = { "bashls", "gopls", "lua_ls", "pyright", "ruff", "rust_analyzer", "ts_ls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "跳转定义" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "跳转声明" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "悬浮文档" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "查找实现" }))
        vim.keymap.set("n", "gh", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "查找引用" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "重命名" }))
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "代码操作" }))
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "签名帮助" }))
        vim.keymap.set("n", "go", "<cmd>Trouble symbols toggle win.position=right<CR>", vim.tbl_extend("force", bufopts, { desc = "符号大纲" }))
        vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, vim.tbl_extend("force", bufopts, { desc = "上个诊断" }))
        vim.keymap.set("n", "g]", vim.diagnostic.goto_next, vim.tbl_extend("force", bufopts, { desc = "下个诊断" }))

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      local servers = { "bashls", "gopls", "pyright", "ruff", "rust_analyzer", "ts_ls", "lua_ls" }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
