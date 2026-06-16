# dotfiles — macOS 开发环境

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

个人 macOS 开发环境配置，使用 GNU Stow 管理。覆盖终端模拟器、Shell、编辑器、Git、包管理、Docker 等全栈工具链，统一 Tokyo Night Storm 视觉风格。

## 组件概览

### 终端与 Shell

| 组件 | 工具 | 说明 |
|------|------|------|
| 终端模拟器 | [Ghostty](https://ghostty.org) | GPU 加速渲染，原生 macOS 毛玻璃效果 |
| Shell | Zsh + [Zimfw](https://github.com/zimfw/zimfw) | 模块化框架，< 50ms 启动 |
| 提示符 | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Pure 风格，transient + instant prompt |
| 字体 | Maple Mono NF 14pt | Nerd Font 全图标覆盖 |
| 配色 | Tokyo Night Storm | 贯穿所有终端工具 |

### 工具链

```
eza        → ls        bat        → cat        rg         → grep
fd         → find      delta      → diff       fzf        → 模糊搜索
zoxide     → cd        atuin      → history    btop       → top
lazygit    → git TUI   zellij     → tmux       yazi       → 文件管理
mise       → 运行时    carapace   → 补全       direnv     → 环境变量
fastfetch  → 系统信息  just       → 任务编排
```

### Neovim 配置

59 个插件，233ms 冷启动，覆盖以下能力：

| 能力 | 插件选型 |
|------|----------|
| **插件管理** | lazy.nvim — 按需加载，并行安装 |
| **文件树** | nvim-tree + edgy.nvim — 左栏文件树，右侧 AI 聊天，底部终端/问题列表 |
| **搜索** | telescope.nvim + fzf-native（文件检索、文本搜索、undo 历史、buffer 切换、live-grep） |
| **补全** | nvim-cmp + luasnip — LSP / snippet / path / buffer 多来源 |
| **LSP** | lspconfig + mason.nvim + conform.nvim — pyright / gopls / lua_ls / rust_analyzer / ts_ls / ruff / bashls |
| **语法高亮** | treesitter — 60+ 语言，配合 textobjects 实现结构化编辑 |
| **AI 补全** | supermaven-nvim — 免费云端补全，< 50ms 响应 |
| **AI 聊天** | codecompanion.nvim — OpenRouter 免费模型，Agent 模式可直接读写文件、执行命令 |
| **调试** | nvim-dap + nvim-dap-ui — Python / Go / C++ / Rust 断点调试 |
| **Git** | gitsigns（行内标记）+ vim-fugitive（Git 操作）+ diffview.nvim（对比视图） |
| **界面美化** | lualine（状态栏）+ bufferline.nvim（标签栏）+ noice.nvim（浮动命令行）+ Tokyo Night |
| **跳转导航** | hop.nvim（单词/行/字符快速定位）+ flash.nvim（语法树跳转）|
| **窗口管理** | smart-splits.nvim — Ctrl 方向键导航，Alt 方向键调整大小 |
| **会话管理** | persisted.nvim — 自动保存/恢复会话，支持目录会话 |
| **快捷键引导** | which-key.nvim — 按 `<leader>` 弹出汉化菜单 |

### 快捷键体系

- `<leader>` 为空格键，所有操作用中文描述
- `g` 开头为 Git 操作（`gs` 暂存、`gb` blame、`gp` push、`gl` pull）
- `Tab` / `S-Tab` 切换 buffer，`A-i` / `A-o` 前后切换，`A-1`~`A-9` 按编号跳转
- `tn` / `tj` / `tk` / `to` 管理 Vim 标签页
- `<leader>r` 在底部面板运行当前文件代码
- `<leader>cc` 打开 AI 聊天，`<leader>ca` 将当前文件加入上下文
- `<C-n>` 切换左侧文件树

## 目录结构

```
dotfiles/
├── zsh/           .zshenv .zprofile .zshrc     — Zimfw 加载 + 工具链集成
├── zim/           .zimrc                       — Zim 模块声明
├── p10k/          .p10k.zsh                    — Powerlevel10k 配置
├── git/           .gitconfig                   — SSH 别名、代理、全局 gitignore
├── ghostty/       config                       — Tokyo Night Storm 内置主题
├── yazi/          yazi.toml + keymap.toml      — 文件管理器
├── zellij/        config.kdl                   — 终端多路复用器
├── btop/          btop.conf                    — 系统监控
├── fastfetch/     config.jsonc                 — 系统信息
├── lazygit/       config.yml                   — Git TUI
├── nvim/          Neovim 配置                  — 59 插件
├── brew/          .Brewfile                    — Homebrew 包声明
├── conda/         .condarc                     — USTC 镜像
├── npm/           .npmrc                       — npmmirror 镜像
├── pip/           pip.conf                     — 清华源
├── docker/        docker-compose-ai.yml        — AI 本地服务栈
├── configure                                     — Stow 部署脚本
└── justfile                                       — 任务编排
```

## 快速部署

```bash
git clone git@github.com:1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles
./configure link          # 建立 symlink
brew bundle --file .Brewfile  # 安装系统包
zimfw install             # 安装 Zsh 模块
mise install              # 安装运行时
atuin login && atuin sync # 同步历史
exec zsh                  # 重开终端
```

部署后执行 `./configure doctor` 验证全部 symlink。

## 安全

- API 密钥存储在 macOS Keychain，`.zshenv` 启动时自动加载
- Git 通过 SSH 别名认证（`git@github.com`），避免令牌泄漏
- 代理仅使用本地 ClashX 混合端口 `7892`，不写死远程地址

## 依赖

- macOS (Apple Silicon)
- [Homebrew](https://brew.sh)
- Git

## License

MIT
