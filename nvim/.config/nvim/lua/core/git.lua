-- core/git.lua — 原生 Git 操作面板
-- 功能: status / commit / push / pull / branch / log / clone
-- TODO: 快捷键注册在 keymaps.lua

local M = {}

local function run(args)
	return vim.fn.system("git " .. args)
end

local function run_silent(args)
	local ok, result = pcall(vim.fn.system, "git " .. args)
	if not ok then
		vim.notify("Git 错误: " .. tostring(result), vim.log.levels.ERROR)
		return nil
	end
	return vim.trim(result or "")
end

function M.status()
	local output = run("status")
	if vim.v.shell_error ~= 0 then
		vim.notify("不是 git 仓库", vim.log.levels.ERROR)
		return
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "git://status")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	vim.api.nvim_set_current_buf(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].modified = false
	vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = buf, silent = true, desc = "关闭" })
end

function M.commit()
	vim.ui.input({ prompt = "提交信息: " }, function(msg)
		if not msg or msg == "" then
			return
		end
		local result = run_silent("commit -m " .. vim.fn.shellescape(msg))
		if result then
			vim.notify("Commit: " .. result)
		end
	end)
end

function M.commit_all()
	vim.ui.input({ prompt = "提交信息: " }, function(msg)
		if not msg or msg == "" then
			return
		end
		local result = run_silent("add -A && git commit -m " .. vim.fn.shellescape(msg))
		if result then
			vim.notify("Commit: " .. result)
		end
	end)
end

function M.push()
	local result = run_silent("push")
	if result then
		vim.notify("Push: " .. result)
	end
end

function M.pull()
	local result = run_silent("pull")
	if result then
		vim.notify("Pull: " .. result)
	end
end

function M.log()
	local output = run("log --oneline --graph --all -30")
	if vim.v.shell_error ~= 0 then
		vim.notify("不是 git 仓库", vim.log.levels.ERROR)
		return
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "git://log")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	vim.api.nvim_set_current_buf(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].modified = false
	vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = buf, silent = true, desc = "关闭" })
end

function M.branch()
	local output = run("branch -a")
	if vim.v.shell_error ~= 0 then
		vim.notify("不是 git 仓库", vim.log.levels.ERROR)
		return
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "git://branch")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	vim.api.nvim_set_current_buf(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].modified = false
	vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = buf, silent = true, desc = "关闭" })
	-- Enter on a branch to switch
	vim.keymap.set("n", "<CR>", function()
		local line = vim.fn.getline(".")
		local branch = line:match("%*?%s*(.+)")
		if branch then
			local result = run_silent("switch " .. vim.fn.shellescape(branch))
			if result then
				vim.notify("切换到: " .. branch)
				vim.cmd("q!")
			end
		end
	end, { buffer = buf, silent = true, desc = "切换分支" })
end

function M.clone()
	vim.ui.input({ prompt = "仓库 URL: " }, function(url)
		if not url or url == "" then
			return
		end
		vim.ui.input({ prompt = "目标目录 (空=当前目录): " }, function(dir)
			local cmd = "clone " .. vim.fn.shellescape(url)
			if dir and dir ~= "" then
				cmd = cmd .. " " .. vim.fn.shellescape(dir)
			end
			vim.notify("克隆中: " .. url)
			local result = run_silent(cmd)
			if result then
				vim.notify("Clone: " .. result)
			end
		end)
	end)
end

function M.diff()
	local output = run("diff --color=never")
	if vim.v.shell_error ~= 0 then
		vim.notify("不是 git 仓库", vim.log.levels.ERROR)
		return
	end
	if output == "" then
		vim.notify("没有未暂存的变更")
		return
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "git://diff")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	vim.api.nvim_set_current_buf(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].modified = false
	vim.bo[buf].syntax = "diff"
	vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = buf, silent = true, desc = "关闭" })
end

return M
