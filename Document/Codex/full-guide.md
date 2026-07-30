# 全栈开发环境安装与配置指南

> **适用范围**：macOS (Apple Silicon) | 基于 dotfiles 仓库  
> **最后更新**：2026-07-09  
> **dotfiles 仓库**：`~/dotfiles`（git clone 后通过 stow 管理）

---

## 目录

1. [环境准备](#1-环境准备)
2. [Homebrew 与包管理](#2-homebrew-与包管理)
3. [Shell 配置](#3-shell-配置)
4. [终端模拟器](#4-终端模拟器)
5. [Neovim 编辑器](#5-neovim-编辑器)
6. [运行时管理](#6-运行时管理)
7. [Git 配置](#7-git-配置)
8. [Docker 与 AI 服务栈](#8-docker-与-ai-服务栈)
9. [AI 编码助手](#9-ai-编码助手)
10. [Claude Code](#10-claude-code)
11. [OpenCode](#11-opencode)
12. [Oh My OpenAgent](#12-oh-my-openagent)
13. [Codex CLI](#13-codex-cli)
14. [其他工具](#14-其他工具)
15. [一键部署脚本](#15-一键部署脚本)

---

## 1. 环境准备

### 前置条件

| 项目 | 要求 | 检查命令 |
|------|------|---------|
| macOS | 13+ (Ventura) | `sw_vers` |
| Apple Silicon | M1/M2/M3/M4 | `uname -m`（应输出 `arm64`） |
| Git | 2.30+ | `git --version` |
| 终端 | Ghostty 或 iTerm2 | — |
| Nerd Font | Maple Mono NF CN | `fc-list | grep -i maple` |

### 克隆 dotfiles 仓库

```bash
git clone git@github.com:1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 安装 Stow（配置文件管理工具）

```bash
brew install stow
```

---

## 2. Homebrew 与包管理

### 安装 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 配置镜像源

**npm 镜像**（`npm/.npmrc`）：
```bash
# 部署后生效
ln -s ~/dotfiles/npm/.npmrc ~/.npmrc
```

**pip 镜像**（`pip/.config/pip/pip.conf`）：
```bash
mkdir -p ~/.config/pip
ln -s ~/dotfiles/pip/.config/pip/pip.conf ~/.config/pip/pip.conf
```

### 安装所有 Homebrew 包

```bash
brew bundle --file brew/.Brewfile
```

`.Brewfile` 声明了面向 Python、Go 和 AI 应用开发的核心工具：

#### CLI 工具（Formula）

| 类别 | 工具 | 用途 |
|------|------|------|
| **编辑器** | `neovim` | 主力编辑器 |
| **Shell** | `zsh`, `zimfw`, `zoxide` | Shell 增强 |
| **终端** | `ghostty` | 终端模拟器 |
| **文件管理** | `yazi`, `eza`, `bat`, `fd`, `ripgrep` | 现代替代 `ls/cat/find/grep` |
| **Git** | `git`, `git-delta`, `lazygit`, `gh` | 版本控制 |
| **搜索** | `fzf` | 模糊搜索 |
| **开发** | `uv`, `ruff`, `just`, `mise`, `go` | 构建、检查与运行时 |
| **系统** | `btop`, `fastfetch`, `jq`, `yq` | 监控与数据处理 |
| **网络** | `httpie` | API 调试 |
| **其他** | `colima`, `docker`, `ollama` | 容器与本地 AI |

#### GUI 应用（Cask）

| 应用 | 用途 |
|------|------|
| `ghostty` | GPU 加速终端 |

### 验证安装

```bash
# 检查所有包是否已安装
brew bundle check --file brew/.Brewfile

# 查看已安装的 formula
brew list

# 查看已安装的 cask
brew list --cask
```

---

## 3. Shell 配置

### 3.1 部署配置文件

```bash
cd ~/dotfiles
./configure link
```

这会通过 Stow 建立所有配置文件到 `~/.` 的符号链接。

### 3.2 文件结构

```
~/.zshenv          ← 所有 Shell 共享的轻量环境变量
~/.zprofile        ← 登录 Shell（Homebrew shellenv）
~/.zshrc           ← 交互式入口、历史、键位、P10k、Zimfw
~/.zsh/aliases.zsh      ← 命令别名
~/.zsh/functions.zsh    ← 自定义函数和按需 Keychain
~/.zsh/integrations.zsh ← fzf、zoxide、mise、direnv
```

### 3.3 环境变量（`.zshenv`）

**Keychain 懒加载** — 7 个 API Key 从 macOS 钥匙串读取：

```bash
# 加载的 Key
OPENROUTER_API_KEY     # OpenRouter AI
CLOUDFLARE_AI_TOKEN    # Cloudflare Workers AI
ZEN_API_KEY_1          # Zen Proxy Key 1
ZEN_API_KEY_2          # Zen Proxy Key 2
DEEPSEEK_API_KEY       # DeepSeek API
AGNES_API_KEY          # Agnes AI
```

**Claude Code 配置** — 指向 DeepSeek 官方 API：

```bash
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_API_KEY"
export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-flash"
export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-flash"
export CLAUDE_CODE_AGENT_MODEL="deepseek-v4-pro"
export CLAUDE_CODE_EFFORT_LEVEL="max"
```

### 3.4 登录初始化（`.zprofile`）

```bash
# Homebrew shellenv 自动注入 PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 3.5 交互式配置（`.zshrc`）

**Powerlevel10k Instant Prompt** — 零延迟提示符渲染：

```zsh
# 必须在 .zshrc 最顶部
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

**Zimfw 初始化** — ZSH 模块管理器：

```zsh
ZIM_HOME=~/.zim
source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
source ${ZIM_HOME}/init.zsh
```

### 3.6 模块文件详解

#### `00-env.zsh` — 环境变量

```bash
export LANG=en_US.UTF-8
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME="Tokyo Night Storm"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

**PATH 管理** — 防重复的 `add_path()` 函数：

```bash
add_path "$HOME/go/bin"
add_path "$HOME/.local/bin"
add_path "/opt/homebrew/opt/node@22/bin"
```

#### `60-aliases.zsh` — 命令别名

| 别名 | 实际命令 | 用途 |
|------|---------|------|
| `vim` | `nvim` | 编辑器统一 |
| `cat` | `bat --paging=never` | 语法高亮 |
| `ls` | `eza --icons --group-directories-first` | 彩色目录 |
| `ll` | `eza -la --git` | Git 状态 |
| `lt` | `eza --tree --git` | 树形视图 |
| `grep` | `rg` | ripgrep |
| `diff` | `delta` | 语法高亮 diff |
| `top` | `btop` | 系统监控 |
| `d` | `docker` | Docker 快捷 |
| `dc` | `docker compose` | Compose 快捷 |
| `lg` | `lazygit` | Git TUI |
| `bt` | `btop` | 系统监控 |

**Git 快捷**：

```bash
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias glog='git log --oneline --graph --decorate --all'
alias gclean='git clean -fd'
```

#### `70-functions.zsh` — 自定义函数

**代理管理**：

```bash
proxy on     # 开启代理 (127.0.0.1:7892)
proxy off    # 关闭代理
proxy status # 查看状态
```

**Zen Proxy 管理**：

```bash
zen-proxy start   # 启动 AI 代理（端口 8123）
zen-proxy stop    # 停止
zen-proxy restart # 重启
zen-proxy status  # 查看运行状态
zen-proxy log     # 查看日志
zen-switch        # 切换 API Key
zen-status        # 查看 Key 状态
```

**快捷操作**：

```bash
mkcd foo        # 创建并进入目录
take foo        # 创建并进入（静默）
extract file.zip # 自动解压
note "topic"    # 创建笔记文件
fo              # fzf 选文件打开
gacf "msg"      # fzf 选文件并 git commit
weather Beijing # 天气查询
ipinfo          # IP 信息
port 8080       # 查看端口占用
```

### 3.7 安装 Zim 模块

```bash
zimfw install
```

### 3.8 应用配置

```bash
exec zsh
```

---

## 4. 终端模拟器

### Ghostty（主力终端）

**安装**：

```bash
brew install --cask ghostty
```

**配置**（`ghostty/.config/ghostty/config` → `~/.config/ghostty/config`）：

```
# 字体
font-family = "Maple Mono NF CN"
font-size = 14

# 外观
background-opacity = 0.85
background-blur = macos-glass-regular
window-padding-x = 10
window-padding-y = 10

# 快捷键
keybind = cmd-q=quit
keybind = cmd-shift-=:zoom-window-out
keybind = cmd-shift-=:zoom-window-in

# 系统
option-as-alt = true

# 鼠标
mouse-hide-while-typing = true
```

### 其他终端

| 终端 | 安装 | 配置 |
|------|------|------|
| **iTerm2** | `brew install --cask iterm2` | 手动配置 |
| **Alacritty** | `brew install alacritty` | `~/.config/alacritty/alacritty.toml` |

---

## 5. Neovim 编辑器

### 安装

```bash
brew install neovim
nvim --version  # 应显示 v0.12.x
```

### 配置部署

```bash
cd ~/dotfiles
stow nvim
```

### 插件架构

基于 **lazy.nvim**，54+ 个插件，按功能模块分 22 个文件：

```
~/.config/nvim/lua/plugins/
├── ai.lua          # blink.cmp + avante.nvim + supermaven
├── completion.lua  # （已移至 ai.lua）
├── cursor.lua      # smear-cursor 动画光标
├── debug.lua       # nvim-dap + dap-ui
├── explorer.lua    # oil.nvim + edgy
├── format.lua      # conform.nvim 格式化
├── git.lua         # gitsigns + diffview + fugitive
├── im-select.lua   # 输入法切换
├── lsp.lua         # mason + lspconfig
├── markdown.lua    # render-markdown + markdown-preview
├── mini.lua        # mini.ai + mini.surround + mini.comment + mini.icons
├── misc.lua        # blink.pairs + vim-matchup + nvim-ts-autotag + colorizer
├── neotest.lua     # neotest + python + go
├── snacks.lua      # snacks.nvim（dashboard/picker/indent/animate/scroll/notifier/fold/explorer）
├── theme.lua       # tokyonight + devicons
├── tools.lua       # toggleterm + flash + smart-splits + treesj + grug-far + todo-comments + undotree + persisted
├── ui.lua          # lualine + bufferline + dressing + noice + trouble + which-key
└── treesitter.lua  # nvim-treesitter + textobjects
```

### 核心功能

| 功能 | 插件 | 快捷键 |
|------|------|--------|
| **补全** | blink.cmp | `<C-space>` |
| **括号** | blink.pairs | 自动 |
| **AI 聊天** | avante.nvim | `<leader>aa` |
| **AI 补全** | supermaven | `<C-y>` 接受 |
| **LSP** | mason + lspconfig | `gd` 定义 / `gr` 重命名 |
| **格式化** | conform.nvim | `<A-S-f>` |
| **搜索** | snacks.picker | `<leader>ff` 文件 / `<leader>fg` 全文 |
| **文件树** | snacks.explorer | `<leader>n` |
| **Git** | gitsigns + diffview | `]g/[g` hunk 导航 |
| **调试** | nvim-dap | `<F6>` 继续 / `<F8>` 断点 |
| **终端** | snacks.terminal | `<A-d>` 浮动终端 |
| **标签页** | bufferline | `<Tab>/<S-Tab>` |
| **窗口** | smart-splits | `<C-h/j/k/l>` 导航 |

### 首次启动

```bash
nvim
# 自动执行 :Lazy! sync 安装所有插件
```

---

## 6. 运行时管理

### Mise（统一运行时版本管理）

**安装**：

```bash
brew install mise
```

**配置**（`mise/.config/mise/config.toml` → `~/.config/mise/config.toml`）：

```toml
[settings]
experimental = true
jobs = 3

[tools]
node = "22"
python = "3.12"
go = "latest"
rust = "latest"
```

**安装所有运行时**：

```bash
mise install
```

### uv（Python 包管理）

```bash
# 在具体项目中创建并同步环境
uv init
uv add openai anthropic
uv sync
```

---

## 7. Git 配置

### 部署

```bash
cd ~/dotfiles
stow git
```

### 配置内容（`.gitconfig`）

```ini
[user]
    name = Your Name
    email = your@email.com

[core]
    excludesfile = ~/.gitignore_global
    editor = nvim

[push]
    default = current

[fetch]
    prune = true

[diff]
    tool = delta
    pager = delta

[merge]
    conflictstyle = zdiff3
    merge = delta

[credential]
    helper = osxkeychain

[url "git@github.com:"]
    insteadOf = "https://github.com/"
```

### Delta（diff 分页器）

```ini
[delta]
    navigate = true
    side-by-side = true
    line-numbers = true
    syntax-theme = "Tokyo Night Storm"
```

### 全局忽略（`.gitignore_global`）

```
.DS_Store
*.swp
*.swo
*~
.idea/
.vscode/
*.orig
```

### 快捷别名

```bash
git config --global alias.lg "lazygit"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.st "status"
```

---

## 8. Docker 与 AI 服务栈

### 安装

```bash
brew install docker colima
colima start
```

### AI 服务栈（`docker/docker-compose-ai.yml`）

```yaml
services:
  qdrant:
    image: qdrant/qdrant:v1.15.3
    ports:
      - "127.0.0.1:6333:6333"

  litellm:
    image: ghcr.io/berriai/litellm:main-latest
    profiles: ["llm"]
    ports:
      - "127.0.0.1:4000:4000"
    volumes:
      - ./litellm_config.yaml:/app/config.yaml
    command: ["--config", "/app/config.yaml"]
```

### 启动 AI 栈

```bash
cd ~/dotfiles/docker
docker compose -f docker-compose-ai.yml up -d
# 需要统一模型路由时：
docker compose -f docker-compose-ai.yml --profile llm up -d
```

### Ollama（本地 LLM）

```bash
# 安装
brew install ollama

# 启动
ollama serve

# 拉取模型
ollama pull deepseek-r1:8b
ollama pull llama3.2

# 验证
ollama list
```

---

## 9. AI 编码助手

### 9.1 Claude Code

**安装**：

```bash
brew install opencode
```

**配置部署**：

```bash
cd ~/dotfiles
stow claude
```

**目录结构**：

```
~/.claude/
├── CLAUDE.md          ← 全局系统提示词（OMC 编排 + 安全规则）
├── settings.json      ← Claude Code 设置
├── rules/             ← 26 个按路径匹配的规则文件
├── skills/            ← 38 个 OMC 技能
├── agents/            ← 子智能体定义
├── hooks/             ← 生命周期钩子
└── hud/               ← HUD 显示配置
```

**API Key 配置**（`.zshenv` 中已配置）：

```bash
# Claude Code 通过 DeepSeek API 路由
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_API_KEY"
```

### 9.2 OpenCode

**安装**：

```bash
brew install opencode
```

**配置部署**：

```bash
cd ~/dotfiles
stow opencode
```

**配置**（`~/.config/opencode/opencode.jsonc`）：

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "zen-proxy/deepseek-v4-flash-free",
  "small_model": "zen-proxy/north-mini-code-free",
  "provider": {
    "zen-proxy": {
      "baseURL": "http://127.0.0.1:8123/v1",
      "models": {
        "deepseek-v4-flash-free": { "name": "DeepSeek V4 Flash Free" },
        "north-mini-code-free": { "name": "North Mini Code Free" }
      }
    }
  }
}
```

**启动**：

```bash
opencode
```

---

## 10. Oh My OpenAgent

**安装**：

```bash
npx oh-my-openagent install --no-tui --opencode-zen=yes
```

**配置**（`~/.config/opencode/oh-my-openagent.json`）：

包含 11 个 agent 的模型路由：
- `sisyphus` — 主力 agent（claude-opus-4-7）
- `oracle` — 架构顾问（gpt-5.5）
- `prometheus` — 规划（claude-opus-4-7）
- `explore` — 探索（gpt-5-nano）
- 等...

**验证**：

```bash
bunx oh-my-openagent doctor
```

---

## 11. Codex CLI

**安装**：

```bash
npm install -g @openai/codex
codex --version
```

**登录**：

```bash
# ChatGPT 订阅登录（推荐）
codex login

# 或 API Key 登录
printenv OPENAI_API_KEY | codex login --with-api-key
```

**国内配置**（`~/.codex/config.toml`）：

```toml
model = "openai/gpt-5.4-mini-codex"
sandbox_mode = "workspace-write"
approval_policy = "on-request"

[model_providers.myproxy]
name = "My Proxy"
base_url = "https://your-proxy.example.com/v1"
env_key = "MY_PROXY_API_KEY"
wire_api = "responses"
```

**使用**：

```bash
# 交互式 TUI
codex

# 直接执行
codex "创建一个 Express.js 项目"

# 指定模型
codex --model openai/gpt-5.1-codex-max "重构这个函数"

# 只读模式
codex --sandbox read-only "分析一下项目架构"
```

---

## 12. 其他工具

### Yazi（文件管理器）

```bash
brew install yazi
yazi                          # 启动
yazi <path>                   # 打开指定目录
```

### zellij（终端复用器）

```bash
brew install zellij
zellij attach --create default
```

### LazyGit（Git TUI）

```bash
brew install lazygit
lazygit                       # 启动
```

### btop（系统监控）

```bash
brew install btop
btop                          # 启动（替代 top）
```

### fastfetch（系统信息）

```bash
brew install fastfetch
fastfetch                     # 显示系统信息
```

### gh（GitHub CLI）

```bash
brew install gh
gh auth login                 # 登录 GitHub
gh pr list                    # 列出 PR
gh issue create -t "Bug" -b "..."  # 创建 Issue
```

---

## 13. 一键部署脚本

### 完整部署流程

```bash
# 1. 克隆仓库
git clone git@github.com:1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. 安装 Homebrew（如未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. 安装 Stow
brew install stow

# 4. 部署所有配置
./configure link

# 5. 安装所有 Homebrew 包
brew bundle --file brew/.Brewfile

# 6. 安装 Zim 模块
zimfw install

# 7. 安装运行时
mise install

# 8. 安装 Node 全局包
npm install -g @openai/codex

# 9. 在具体 Python 项目中执行 uv sync

# 10. 启动 Colima + Docker
colima start

# 11. 重开终端
exec zsh

# 12. 验证
./configure doctor
just verify
```

### 日常维护

```bash
# 更新所有包
just update-all

# 代码格式化
just fix

# 代码检查
just lint

# 清理缓存
just cache-clean

# 系统状态检查
just doctor
```

---

## 14. 故障排查

### 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| `command not found: codex` | PATH 未更新 | `exec zsh` 或 `source ~/.zshrc` |
| `command not found: stow` | Stow 未安装 | `brew install stow` |
| Neovim 插件安装失败 | lazy.nvim 未同步 | `:Lazy! sync` |
| API Key 未加载 | Keychain 无对应条目 | `security add-generic-password -s OPENROUTER_API_KEY -w "your-key"` |
| Docker 连接失败 | colima 未运行 | `colima start` |
| ghostty 中文乱码 | 字体缺失 | `brew install --cask font-maple-mono-nf-cn` |
| zsh 启动慢 | 模块过多 | `zimfw install` 重新构建 |

### 日志查看

```bash
# Zen Proxy
cat /tmp/zen-proxy.log

# Lite Proxy
cat /tmp/lite-proxy.log

# Neovim 日志
cat ~/.local/state/nvim/log

# Claude Code 日志
cat ~/.claude/logs/claude.log
```

---

## 15. 配置速查表

### 配置文件位置

| 工具 | 配置文件 | dotfiles 包 |
|------|---------|-------------|
| Shell | `~/.zshrc` | `zsh/` |
| 提示符 | `~/.p10k.zsh` | `p10k/` |
| Git | `~/.gitconfig` | `git/` |
| Neovim | `~/.config/nvim/` | `nvim/` |
| Ghostty | `~/.config/ghostty/config` | `ghostty/` |
| Yazi | `~/.config/yazi/` | `yazi/` |
| zellij | `~/.config/zellij/config.kdl` | `zellij/` |
| btop | `~/.config/btop/` | `btop/` |
| lazygit | `~/.config/lazygit/` | `lazygit/` |
| mise | `~/.config/mise/` | `mise/` |
| Claude Code | `~/.claude/` | `claude/` |
| OpenCode | `~/.config/opencode/` | `opencode/` |
| Codex | `~/.codex/` | — |
| Docker | `~/dotfiles/docker/` | `docker/` |

### 快捷键速查

| 工具 | 快捷键 | 功能 |
|------|--------|------|
| **Shell** | `Ctrl+R` | fzf 历史搜索 |
| | `Alt+C` | fzf 目录跳转 |
| | `z foo` | zoxide 跳转 |
| **Neovim** | `<leader>ff` | 文件搜索 |
| | `<leader>fg` | 全文搜索 |
| | `<leader>aa` | AI 聊天 |
| | `<A-f>` | 切换自动格式化 |
| **Ghostty** | `Cmd+Shift+=` | 放大 |
| | `Cmd+Shift+-` | 缩小 |
| **LazyGit** | `j/k` | 上下导航 |
| | `cc` | 提交 |
| | `gp` | push |
