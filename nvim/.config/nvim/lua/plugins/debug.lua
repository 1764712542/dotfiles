return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
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

      require("dap-python").setup("python3")
      require("dap-go").setup({
        delve = { path = "dlv" },
      })

      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        layouts = {
          { elements = { { id = "scopes", size = 0.50 }, { id = "stacks", size = 0.25 }, { id = "watches", size = 0.25 } }, position = "right", size = 40 },
          { elements = { { id = "repl", size = 0.75 }, { id = "console", size = 0.25 } }, position = "bottom", size = 15 },
        },
        floating = { max_height = 0.8, max_width = 0.7, border = "rounded" },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        virt_text_pos = "eol",
        highlight_changed_variables = true,
        all_frames = true,
      })
    end,
  },
}
