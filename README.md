# dotfiles — macOS 现代化终端配置

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

个人 macOS 开发环境，基于 Zsh + Zimfw + Powerlevel10k，集成现代 CLI 工具链、Tokyo Night 统一视觉体系与 59 插件 Neovim 配置。

## Stack

| 层 | 选择 |
|------|--------|
| **Terminal** | [Ghostty](https://ghostty.org) — GPU 加速、原生毛玻璃 |
| **Shell** | Zsh + [Zimfw](https://github.com/zimfw/zimfw) — 启动 < 50ms |
| **Prompt** | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — Pure 风格，transient + instant prompt |
| **Font** | Maple Mono NF 14pt — Nerd Font 全图标支持 |
| **Theme** | Tokyo Night Storm — 全工具视觉统一 |
| **Editor** | [Neovim 0.12](https://neovim.io) — 59 插件，233ms 启动 |

### Toolchain

```
eza        → ls          bat        → cat          rg         → grep
fd         → find        delta      → diff         fzf        → 模糊搜索
zoxide     → cd          atuin      → history      btop       → top
lazygit    → git TUI     zellij     → tmux          yazi      → 文件管理
mise       → pyenv/nvm   carapace   → completions   direnv     → 环境变量
fastfetch  → neofetch    just       → task runner
```

### Neovim 亮点

| 类别 | 选型 |
|------|------|
| **文件树** | nvim-tree + edgy 侧边栏（左栏 NvimTree + Trouble，右栏 CodeCompanion） |
| **搜索** | telescope + fzf-native（文件/文本/grep/undo/buffer） |
| **补全** | nvim-cmp + luasnip + LSP |
| **LSP** | lspconfig + mason + conform（pyright / gopls / lua_ls / rust_analyzer / ts_ls / ruff / bashls） |
| **AI** | Supermaven（免费补全）+ CodeCompanion（OpenRouter 免费模型，Agent 模式直接读写文件） |
| **调试** | nvim-dap + nvim-dap-ui（Python / Go / C++ / Rust） |
| **界面** | lualine + bufferline + noice + Tokyo Night |
| **跳转** | hop（单词/行/字符）+ flash（语法树）
| **Git** | gitsigns + fugitive + diffview + lazygit |
| **会话** | persisted.nvim（自动保存/恢复） |
| **快捷键** | 对标 nvimdots，全部汉化，which-key 可视引导 |

## Structure

```
dotfiles/
├── zsh/          .zshenv .zprofile .zshrc     — Zimfw + 工具链集成 + API Key
├── zim/          .zimrc                       — Zim 模块声明
├── p10k/         .p10k.zsh                    — Pure 风格 prompt
├── ghostty/      config                       — 内置 tokyonight-storm
├── yazi/         yazi.toml + keymap.toml      — Vim 风格键位
├── zellij/       config.kdl                   — Tokyo Night 主题
├── btop/         btop.conf
├── fastfetch/    config.jsonc                 — Tokyo Night 配色
├── lazylgit/     config.yml                   — Tokyo Night + Vim 键位
├── git/          .gitconfig                   — SSH 别名 + 全局 gitignore
├── conda/        .condarc                     — USTC 镜像
├── npm/          .npmrc                       — npmmirror 镜像
├── pip/          pip.conf
├── brew/         .Brewfile                    — Homebrew 包声明
├── docker/       docker-compose-ai.yml        — AI 服务栈
├── nvim/         Neovim 配置                  — 基于 nvimdots，59 插件
├── configure                                    — Stow 管理脚本
└── justfile                                      — 本地任务编排
```

## Quick Start

```bash
# 1. Clone
git clone git@github.com:1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. 部署 symlink
./configure link

# 3. 安装 Homebrew 包
brew bundle --file ~/.Brewfile

# 4. 安装 Zim 模块
zimfw install

# 5. 安装 mise runtime
mise install

# 6. 同步 atuin 历史
atuin login && atuin sync

# 7. 重开终端
exec zsh
```

恢复后用 `./configure doctor` 验证所有 symlink 正常。

## Features

- **XDG 兼容** — 所有缓存/配置/数据遵循 XDG 规范
- **fzf 深度集成** — 主题化预览、Ctrl+Y 剪贴板、Ctrl+T/Alt+C 文件+目录搜索
- **atuin 历史管理** — 模糊搜索、加密同步、enter_accept 即时执行
- **zoxide 智能跳转** — `z`/`zi`/`za` 秒级目录切换
- **代理自适应** — ClashX 混合端口 7892 自动检测
- **GPU 加速终端** — Ghostty + 毛玻璃 + 活跃会话时隐藏鼠标
- **安全性** — SSH 别名 Git 认证、API 密钥存 macOS Keychain
- **Brewfile 声明式管理** — 换机一条命令还原全部包
- **Neovim AI Agent** — 自带 CodeCompanion Agent 模式，AI 直接读写文件

## Requirements

- macOS (Apple Silicon)
- Homebrew
- Git

## License

MIT
