return function()
	vim.defer_fn(function()
		require("modules.utils").load_plugin("copilot", {
			cmp = {
				enabled = true,
				method = "getCompletionsCycling",
			},
			panel = {
				-- Enable inline panel for Copilot suggestions
				enabled = false,
			},
			suggestion = {
				-- Enable ghost text suggestions (inline AI completion)
				enabled = true,
				auto_trigger = true,
				debounce = 150,
				keymap = {
					accept = "<C-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				["dap-repl"] = false,
				["fugitive"] = false,
				["fugitiveblame"] = false,
				["git"] = false,
				["gitcommit"] = false,
				["log"] = false,
				["toggleterm"] = false,
			},
		})
	end, 100)
end
