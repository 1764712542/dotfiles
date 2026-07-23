local M = {}

local uv = vim.uv
local markers = {
  ".git",
  "justfile",
  "pyproject.toml",
  "uv.lock",
  "go.mod",
  "Cargo.toml",
  "package.json",
  "tsconfig.json",
  "bun.lock",
  "bun.lockb",
  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "Makefile",
  "CMakeLists.txt",
}

local function executable(bin)
  return vim.fn.executable(bin) == 1
end

local function exists(path)
  return path ~= "" and uv.fs_stat(path) ~= nil
end

local function join(root, name)
  return vim.fs.joinpath(root, name)
end

local function has(root, name)
  return exists(join(root, name))
end

local function shellescape(value)
  return vim.fn.shellescape(value)
end

function M.root(bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(0)
  local start = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd()
  local match = vim.fs.find(markers, { upward = true, path = start })[1]
  return match and vim.fs.dirname(match) or start
end

local function python_command(filename, root)
  if has(root, "pyproject.toml") and executable("uv") then
    return "uv run python " .. shellescape(filename)
  end
  local python = join(root, ".venv/bin/python")
  if executable(python) then
    return shellescape(python) .. " " .. shellescape(filename)
  end
  return executable("python3") and ("python3 " .. shellescape(filename)) or nil
end

local function typescript_command(filename, root)
  local local_tsx = join(root, "node_modules/.bin/tsx")
  if executable(local_tsx) then
    return shellescape(local_tsx) .. " " .. shellescape(filename)
  end
  if executable("tsx") then
    return "tsx " .. shellescape(filename)
  end
  return executable("bun") and ("bun run " .. shellescape(filename)) or nil
end

local function rust_command(filename, root)
  if has(root, "Cargo.toml") and executable("cargo") then
    return "cargo run"
  end
  if not executable("rustc") then
    return nil
  end
  local output = vim.fn.tempname()
  return string.format("rustc %s -o %s && %s", shellescape(filename), shellescape(output), shellescape(output))
end

local function compiled_command(ft, filename, root)
  if has(root, "Makefile") and executable("make") then
    return "make"
  end
  if has(root, "CMakeLists.txt") and executable("cmake") then
    return "cmake --build build"
  end
  local compiler = ft == "c" and "gcc" or "g++"
  if not executable(compiler) then
    return nil
  end
  local output = vim.fn.tempname()
  return string.format("%s %s -o %s && %s", compiler, shellescape(filename), shellescape(output), shellescape(output))
end

local function project_command(ft, filename, root)
  if ft == "python" then
    return python_command(filename, root)
  elseif ft == "typescript" or ft == "typescriptreact" then
    return typescript_command(filename, root)
  elseif ft == "rust" then
    return rust_command(filename, root)
  elseif ft == "go" and executable("go") then
    return has(root, "go.mod") and "go run ." or ("go run " .. shellescape(filename))
  elseif ft == "javascript" or ft == "javascriptreact" then
    return executable("node") and ("node " .. shellescape(filename)) or nil
  elseif ft == "lua" then
    return executable("lua") and ("lua " .. shellescape(filename)) or nil
  elseif ft == "bash" or ft == "sh" then
    return executable("bash") and ("bash " .. shellescape(filename)) or nil
  elseif ft == "c" or ft == "cpp" then
    return compiled_command(ft, filename, root)
  end
end

local function package_verify(root)
  local scripts = vim.fn.json_decode(table.concat(vim.fn.readfile(join(root, "package.json")), "\n")).scripts or {}
  local runner = (has(root, "bun.lock") or has(root, "bun.lockb")) and "bun run" or "npm run"
  local commands = {}
  for _, name in ipairs({ "lint", "typecheck", "test" }) do
    if scripts[name] then
      commands[#commands + 1] = runner .. " " .. name
    end
  end
  return #commands > 0 and table.concat(commands, " && ") or nil
end

local function verify_command(root)
  local justfile = has(root, "justfile") and vim.fn.readfile(join(root, "justfile")) or {}
  local has_verify = vim.iter(justfile):any(function(line)
    return line:match("^verify[%s:(]") ~= nil
  end)
  if has_verify and executable("just") then
    return "just verify"
  elseif has(root, "pyproject.toml") and executable("uv") then
    return "uv run ruff check . && uv run pytest"
  elseif has(root, "go.mod") and executable("go") then
    return "go test ./..."
  elseif has(root, "Cargo.toml") and executable("cargo") then
    return "cargo check && cargo test"
  elseif has(root, "package.json") then
    return package_verify(root)
  end
end

local function close_previous_runner()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_run_terminal then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

local function open_terminal(cmd, root)
  close_previous_runner()
  vim.cmd("belowright 12new")
  vim.fn.termopen(cmd, {
    cwd = root,
    on_exit = function(_, code)
      vim.schedule(function()
        vim.notify(
          code == 0 and "命令执行完成" or ("命令失败，退出码: " .. code),
          code == 0 and nil or vim.log.levels.ERROR
        )
      end)
    end,
  })
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].is_run_terminal = true
  vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })
  vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = buf, silent = true })
end

function M.run_current_file()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" or not pcall(vim.cmd, "silent write") then
    vim.notify("请先保存文件", vim.log.levels.WARN)
    return
  end
  local root = M.root(filename)
  local cmd = project_command(vim.bo.filetype, filename, root)
  if not cmd then
    vim.notify("当前文件类型缺少可用运行命令或工具链: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  open_terminal(cmd, root)
end

function M.verify_project()
  local root = M.root()
  local cmd = verify_command(root)
  if not cmd then
    vim.notify("未找到可用的项目验证命令", vim.log.levels.WARN)
    return
  end
  open_terminal(cmd, root)
end

function M.open_agent(command)
  if not executable(command) then
    vim.notify("找不到命令: " .. command, vim.log.levels.WARN)
    return
  end
  require("snacks").terminal(command, { cwd = M.root() })
end

return M
