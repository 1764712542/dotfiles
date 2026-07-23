-- ==========================================
-- plugins/lsp.lua — LSP 客户端配置
-- 部署路径: .config/nvim/lua/plugins/lsp.lua
-- 所属包: nvim/
-- 功能: 通过 mason + lspconfig 管理语言服务器（bash/go/lua/python/typescript）
-- 注意事项: 需要 Neovim >= 0.11（vim.lsp.config API）
-- ==========================================
-- Neovim >= 0.11 required for vim.lsp.config / vim.lsp.enable API
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.notify("LSP config requires Neovim >= 0.11", vim.log.levels.ERROR)
  return {}
end

local servers = { "bashls", "gopls", "jsonls", "lua_ls", "pyright", "ruff", "rust_analyzer", "ts_ls", "yamlls" }

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
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = servers,
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "SmiteshP/nvim-navic",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "跳转定义" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "跳转声明" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "悬浮文档" }))
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", bufopts, { desc = "查找实现" })
        )
        vim.keymap.set(
          "n",
          "<leader>lr",
          vim.lsp.buf.references,
          vim.tbl_extend("force", bufopts, { desc = "查找引用" })
        )
        vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "重命名" }))
        vim.keymap.set(
          "n",
          "<leader>la",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", bufopts, { desc = "代码操作" })
        )
        vim.keymap.set(
          "n",
          "gs",
          vim.lsp.buf.signature_help,
          vim.tbl_extend("force", bufopts, { desc = "签名帮助" })
        )
        vim.keymap.set(
          "n",
          "<leader>ls",
          "<cmd>Trouble symbols toggle win.position=right<CR>",
          vim.tbl_extend("force", bufopts, { desc = "符号大纲" })
        )
        vim.keymap.set("n", "g[", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, vim.tbl_extend("force", bufopts, { desc = "上个诊断" }))
        vim.keymap.set("n", "g]", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, vim.tbl_extend("force", bufopts, { desc = "下个诊断" }))

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        local ok, navic = pcall(require, "nvim-navic")
        if ok and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
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

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/compose-spec.json"] = "docker-compose*.yml",
            },
          },
        },
      })

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
  {
    "SmiteshP/nvim-navic",
    opts = {},
  },
}
