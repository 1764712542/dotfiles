local Fm = {}
Fm.__index = Fm

local state = {
	buf = nil,
	win = nil,
	cwd = nil,
	show_hidden = false,
}

function Fm.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
		state.buf = nil
		return
	end
	state.cwd = vim.fn.expand("%:p:h")
	if state.cwd == "" then
		state.cwd = vim.uv.cwd()
	end
	Fm.open()
end

function Fm.open()
	vim.cmd("leftabove 36vnew")
	state.buf = vim.api.nvim_get_current_buf()
	state.win = vim.api.nvim_get_current_win()
	vim.bo[state.buf].filetype = "fm"
	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].modified = false
	vim.api.nvim_buf_set_name(state.buf, "fm://" .. state.cwd)
	Fm.render()
	Fm.set_mappings()
	Fm.go_to_cwd()
end

function Fm.render()
	local items = Fm.list_dir(state.cwd)
	local lines = {}
	for _, item in ipairs(items) do
		table.insert(lines, item.display)
	end
	vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
end

function Fm.list_dir(dir)
	local ok, entries = pcall(vim.fn.readdir, dir)
	if not ok then
		return {}
	end
	local items = {}
	for _, name in ipairs(entries) do
		if name ~= "." and name ~= ".." then
			if state.show_hidden or name:sub(1, 1) ~= "." then
				local full = dir .. "/" .. name
				local is_dir = vim.fn.isdirectory(full) == 1
				local display = (is_dir and "  " or "  ") .. name
				if is_dir then
					display = display .. "/"
				end
				table.insert(items, {
					name = name,
					full = full,
					is_dir = is_dir,
					display = display,
				})
			end
		end
	end
	table.sort(items, function(a, b)
		if a.is_dir ~= b.is_dir then
			return a.is_dir
		end
		return a.name < b.name
	end)
	return items
end

function Fm.get_item_at_cursor()
	local line = vim.api.nvim_win_get_cursor(state.win)[1]
	if line < 1 then
		return nil
	end
	local items = Fm.list_dir(state.cwd)
	return items[line]
end

function Fm.open_selected()
	local item = Fm.get_item_at_cursor()
	if not item then
		return
	end
	if item.is_dir then
		state.cwd = item.full
		vim.api.nvim_buf_set_name(state.buf, "fm://" .. state.cwd)
		Fm.render()
		Fm.go_to_cwd()
	else
		vim.cmd("tabedit " .. vim.fn.fnameescape(item.full))
		Fm.close_sidebar()
	end
end

function Fm.go_up()
	local parent = vim.fn.fnamemodify(state.cwd, ":h")
	if parent ~= state.cwd then
		state.cwd = parent
		vim.api.nvim_buf_set_name(state.buf, "fm://" .. state.cwd)
		Fm.render()
		Fm.go_to_cwd()
	end
end

function Fm.go_to_cwd()
	-- Focus the entry matching cwd basename if possible
	vim.cmd("normal! gg")
end

function Fm.close_sidebar()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
	state.buf = nil
end

-- Operations

function Fm.new_file()
	vim.ui.input({ prompt = "文件名: " }, function(name)
		if not name or name == "" then
			return
		end
		local full = state.cwd .. "/" .. name
		local ok, err = pcall(function()
			io.open(full, "w"):close()
		end)
		if ok then
			Fm.render()
		else
			vim.notify("创建失败: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

function Fm.new_dir()
	vim.ui.input({ prompt = "目录名: " }, function(name)
		if not name or name == "" then
			return
		end
		local full = state.cwd .. "/" .. name
		local ok, err = pcall(vim.fn.mkdir, full, "p")
		if ok then
			Fm.render()
		else
			vim.notify("创建失败: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

function Fm.delete()
	local item = Fm.get_item_at_cursor()
	if not item then
		return
	end
	vim.ui.input({ prompt = "确认删除 " .. item.name .. "? (y/n): " }, function(ans)
		if ans ~= "y" then
			return
		end
		local ok, err
		if item.is_dir then
			ok, err = pcall(vim.fn.delete, item.full, "rf")
		else
			ok, err = pcall(vim.fn.delete, item.full)
		end
		if ok then
			Fm.render()
		else
			vim.notify("删除失败: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

function Fm.rename()
	local item = Fm.get_item_at_cursor()
	if not item then
		return
	end
	vim.ui.input({ prompt = "新名称: ", default = item.name }, function(name)
		if not name or name == "" or name == item.name then
			return
		end
		local full = state.cwd .. "/" .. name
		local ok, err = pcall(vim.fn.rename, item.full, full)
		if ok then
			Fm.render()
		else
			vim.notify("重命名失败: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

function Fm.refresh()
	Fm.render()
	vim.notify("已刷新")
end

function Fm.toggle_hidden()
	state.show_hidden = not state.show_hidden
	Fm.render()
end

-- Mappings

function Fm.set_mappings()
	local buf = state.buf
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, nowait = true, desc = desc })
	end

	map("n", "<CR>", function()
		Fm.open_selected()
	end, "打开")
	map("n", "l", function()
		Fm.open_selected()
	end, "打开")
	map("n", "h", function()
		Fm.go_up()
	end, "上级目录")
	map("n", "-", function()
		Fm.go_up()
	end, "上级目录")
	map("n", "q", function()
		Fm.close_sidebar()
	end, "关闭")
	map("n", "a", function()
		Fm.new_file()
	end, "新建文件")
	map("n", "A", function()
		Fm.new_dir()
	end, "新建目录")
	map("n", "d", function()
		Fm.delete()
	end, "删除")
	map("n", "r", function()
		Fm.rename()
	end, "重命名")
	map("n", ".", function()
		Fm.toggle_hidden()
	end, "显示隐藏")
	map("n", "R", function()
		Fm.refresh()
	end, "刷新")
	map("n", "j", "<cmd>norm! j<CR>", "下移")
	map("n", "k", "<cmd>norm! k<CR>", "上移")
	map("n", "gg", "<cmd>norm! gg<CR>", "顶部")
	map("n", "G", "<cmd>norm! G<CR>", "底部")
end

return Fm
