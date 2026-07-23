-- ==========================================
-- plugins/debug.lua — DAP 调试器
-- 部署路径: .config/nvim/lua/plugins/debug.lua
-- 所属包: nvim/
-- 功能: nvim-dap + dap-ui，支持 Python/Go/Rust 调试
-- ==========================================
return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F6>",
        function()
          require("dap").continue()
        end,
        desc = "继续",
      },
      {
        "<F7>",
        function()
          require("dap").terminate()
        end,
        desc = "停止",
      },
      {
        "<F8>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "断点",
      },
      {
        "<F9>",
        function()
          require("dap").step_into()
        end,
        desc = "步入",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "步过",
      },
      {
        "<F11>",
        function()
          require("dap").step_out()
        end,
        desc = "步出",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "继续",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "断点切换",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("条件: "))
        end,
        desc = "条件断点",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "单步跳过",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "单步进入",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "单步跳出",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "终止调试",
      },
      {
        "<leader>dr",
        function()
          require("dapui").toggle()
        end,
        desc = "调试界面",
      },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_codelldb = vim.fs.joinpath(vim.fn.stdpath("data"), "mason/bin/codelldb")

      if vim.fn.executable("python3") == 1 then
        require("dap-python").setup("python3")
        require("dap-python").resolve_python = function()
          local root = require("core.runner").root()
          local project_python = vim.fs.joinpath(root, ".venv/bin/python")
          return vim.uv.fs_stat(project_python) and project_python or vim.fn.exepath("python3")
        end
      end
      if vim.fn.executable("dlv") == 1 then
        require("dap-go").setup({
          delve = { path = "dlv" },
        })
      end
      if vim.fn.executable("codelldb") == 1 or vim.uv.fs_stat(mason_codelldb) then
        local codelldb = vim.fn.executable("codelldb") == 1 and "codelldb" or mason_codelldb
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = { command = codelldb, args = { "--port", "${port}" } },
        }
        dap.configurations.rust = {
          {
            name = "启动 Rust 可执行文件",
            type = "codelldb",
            request = "launch",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            program = function()
              local target = vim.fs.joinpath(require("core.runner").root(), "target/debug/")
              return vim.fn.input("可执行文件: ", target, "file")
            end,
          },
        }
      end

      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.50 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "right",
            size = 40,
          },
          {
            elements = { { id = "repl", size = 0.75 }, { id = "console", size = 0.25 } },
            position = "bottom",
            size = 15,
          },
        },
        floating = { max_height = 0.8, max_width = 0.7, border = "rounded" },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        virt_text_pos = "eol",
        highlight_changed_variables = true,
        all_frames = true,
      })
    end,
  },
}
