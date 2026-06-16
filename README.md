# dotfiles — macOS 开发环境配置

使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理的全栈开发环境配置，覆盖终端模拟器、Shell、编辑器、版本控制、容器化工具等。所有组件统一 Tokyo Night Storm 配色方案。

## 目录结构

```
dotfiles/
├── zsh/           .zshenv .zprofile .zshrc
├── zim/           .zimrc
├── p10k/          .p10k.zsh
├── git/           .gitconfig
├── ghostty/       config
├── yazi/          yazi.toml + keymap.toml
├── zellij/        config.kdl
├── btop/          btop.conf
├── fastfetch/     config.jsonc
├── lazygit/       config.yml
├── nvim/          .config/nvim/
├── conda/         .condarc
├── npm/           .npmrc
├── pip/           pip.conf
├── brew/          .Brewfile
├── docker/        docker-compose-ai.yml
├── configure       — 部署脚本
└── justfile        — 任务编排
```

### 配置文件说明

#### Shell 环境 (`zsh/`, `zim/`, `p10k/`)

- **`.zshenv`** — 所有 Shell 共享环境变量（PATH、cargo、编辑器变量）
- **`.zprofile`** — 登录 Shell 初始化（Homebrew、包管理器、conda 延迟加载）
- **`.zshrc`** — 交互式 Shell 配置（Zimfw 加载、工具链别名、fzf 键位、补全、atuin 历史、zoxide 目录跳转、Powerlevel10k 提示符、代理检测、conda 延迟加载）
- **`.zimrc`** — Zimfw 模块声明清单
- **`.p10k.zsh`** — Powerlevel10k Pure 风格配置，transient prompt + instant prompt

#### 版本控制 (`git/`)

- **`.gitconfig`** — 全局 Git 配置，包含：
  - SSH 别名认证（`git@github.com` → HTTPS 映射）
  - 全局 gitignore（macOS 系统文件、编辑器临时文件、编译产物）
  - delta 作为 diff 分页器（语法高亮 + 行号）
  - 代理配置（SOCKS5 127.0.0.1:7892）
  - 别名（`lg` = lazygit, `st` = status, `co` = checkout, `br` = branch）

#### 终端工具

- **Ghostty** (`ghostty/`)
  - GPU 加速终端渲染
  - macOS 毛玻璃效果（`background-blur = macos-glass-regular`）
  - 内置 Tokyo Night Storm 主题
  - Maple Mono NF 14pt 字体
  - 鼠标空闲自动隐藏

- **Yazi** (`yazi/`) — 终端文件管理器
  - Vim 风格键位（`j`/`k` 上下、`h`/`l` 进入/退出目录）
  - 文件预览（代码语法高亮、图片、PDF、视频）
  - Tokyo Night 配色

- **Zellij** (`zellij/`) — 终端多路复用器
  - Tokyo Night 主题
  - 自定义布局：主编辑区 + 底部终端 + 右侧文件树
  - 鼠标支持

- **btop** (`btop/`) — 系统监控
  - Tokyo Night 配色
  - CPU / 内存 / 磁盘 / 网络 / 进程实时监控
  - GPU 监控（Apple Silicon Metal）

- **fastfetch** (`fastfetch/`) — 系统信息
  - Tokyo Night 配色
  - 显示系统 / 内核 / Shell / 终端 / CPU / GPU / 内存 / 磁盘信息
  - 首次交互式终端自动显示，不覆盖 zellij 内会话

- **lazygit** (`lazygit/`) — Git TUI
  - Tokyo Night 主题
  - Vim 风格键位
  - 自定 panels 布局

#### 包管理

- **Homebrew** (`brew/.Brewfile`) — 声明式包管理
  - 所有 Homebrew formulae / casks / mas 应用
  - `brew bundle --file .Brewfile` 一键还原

- **conda** (`conda/.condarc`) — Python 环境管理
  - USTC 镜像源（`mirrors.ustc.edu.cn`）
  - 延迟加载：首次调用 `conda` 命令时才初始化

- **npm** (`npm/.npmrc`) — Node.js 包管理
  - npmmirror 镜像源

- **pip** (`pip/pip.conf`) — Python 包管理
  - 清华镜像源

#### 容器化

- **Docker** (`docker/docker-compose-ai.yml`) — AI 服务栈
  - Ollama（本地 LLM 推理）
  - Open WebUI（Web 聊天界面）
  - Qdrant（向量数据库）
  - pgvector（PostgreSQL 向量扩展）

### Neovim 配置

基于 lazy.nvim，59 个插件，按功能模块划分。

#### 核心插件加载 (`init.lua`)

- **lazy.nvim** — 插件管理器，并行安装、按需加载、内置 UI

#### 文件树与侧边栏

| 插件 | 用途 |
|------|------|
| nvim-tree.lua | 文件树浏览器（左侧） |
| edgy.nvim | 可编程侧边栏布局（左：文件树 + Trouble，右：AI 聊天，底：终端 + 问题列表 + 帮助） |

#### 搜索

| 插件 | 用途 |
|------|------|
| telescope.nvim | 模糊搜索框架 |
| fzf-native | telescope 高性能排序引擎 |
| telescope-undo.nvim | undo 历史可视化搜索 |
| telescope-live-grep-args.nvim | 实时 grep 搜索 |

#### 补全与片段

| 插件 | 用途 |
|------|------|
| nvim-cmp | 补全引擎 |
| luasnip | 代码片段引擎 |
| cmp-nvim-lsp | LSP 补全来源 |
| cmp-buffer | 当前 buffer 补全 |
| cmp-path | 文件路径补全 |
| cmp-emoji | Emoji 补全 |
| friendly-snippets | 预置代码片段库 |
| lspkind.nvim | 补全菜单图标 |

#### LSP 与格式化

| 插件 | 用途 |
|------|------|
| mason.nvim | LSP / DAP / linter / formatter 安装管理 |
| mason-lspconfig.nvim | mason ↔ lspconfig 桥接 |
| nvim-lspconfig | LSP 客户端配置 |
| conform.nvim | 代码格式化（保存时自动 / 手动触发） |
| none-ls.nvim | 非 LSP 工具的 LSP 接口 |
| trouble.nvim | LSP 诊断 / 引用 / 符号列表 |

支持的语言和 LSP 服务器：bashls / gopls / lua_ls / pyright / ruff / rust_analyzer / ts_ls

#### AI 辅助

| 插件 | 用途 |
|------|------|
| supermaven-nvim | 云端 AI 代码补全（免费，< 50ms 响应） |
| codecompanion.nvim | AI 聊天助手，支持 Agent 模式直接读写文件 |

CodeCompanion 使用 OpenRouter API，支持任意模型切换。Agent 模式下可自动创建、读取、编辑文件，执行命令，搜索代码。

#### 调试

| 插件 | 用途 |
|------|------|
| nvim-dap | 调试适配器协议客户端 |
| nvim-dap-ui | 调试界面（变量/堆栈/断点/监视） |
| mason-nvim-dap.nvim | DAP 适配器自动安装 |

支持 Python / Go / C++ / Rust 断点调试。

#### 界面美化

| 插件 | 用途 |
|------|------|
| tokyonight.nvim | 配色方案（Tokyo Night Storm） |
| lualine.nvim | 状态栏 |
| bufferline.nvim | 标签栏（显示 buffer） |
| noice.nvim | 浮动命令行 + 通知 + 消息历史 |
| nvim-web-devicons | 文件类型图标 |
| which-key.nvim | 快捷键弹出引导 |

#### 编辑器增强

| 插件 | 用途 |
|------|------|
| nvim-treesitter | 语法树高亮 + 增量解析 |
| nvim-treesitter-textobjects | 结构化文本对象（function/class/block 内/外选择、移动） |
| treesj | 代码行拆分/合并 |
| grug-far.nvim | 项目范围搜索替换（支持 ripgrep） |
| comment.nvim | 代码注释（`gc` / `gcc`） |
| nvim-autopairs | 括号自动补全 |
| hop.nvim | 快速跳转（单词/行/字符/双字符） |
| flash.nvim | Treesitter 感知的快速跳转 |
| persistence.nvim → persisted.nvim | 会话自动保存/恢复 |
| nvim-bufdel | 安全关闭 buffer（保留窗口布局） |
| smart-splits.nvim | 窗口间智能导航与调整 |
| colorizer.lua | 颜色代码高亮预览 |
| indent-blankline.nvim | 缩进指示线 |
| dressing.nvim | 内置 UI（vim.ui.input/select）美化 |
| dropbar.nvim | 面包屑导航 Winbar |

#### Git 集成

| 插件 | 用途 |
|------|------|
| gitsigns.nvim | Git 行内标记（增删改）、hunk 导航、blame |
| vim-fugitive | Git 操作（`:G` 系列命令） |
| diffview.nvim | 对比视图（commit / branch / staged） |

#### 快捷键

| 分类 | 键位 | 作用 |
|------|------|------|
| **Buffer 管理** | `<Tab>` / `<S-Tab>` | 下/上一个 buffer |
| | `<A-i>` / `<A-o>` | 下/上一个 buffer |
| | `<A-1>` .. `<A-9>` | 跳转到 buffer 1~9 |
| | `<A-q>` | 关闭当前 buffer |
| | `<A-S-i>` / `<A-S-o>` | 当前 buffer 右移/左移 |
| | `<leader>bb` | Telescope buffer 列表 |
| | `<leader>bn` / `bp` / `bd` | 下一个 / 上一个 / 关闭 |
| **文件树** | `<C-n>` | 切换左侧栏 |
| | `<leader>nf` | 定位当前文件 |
| | `<leader>nr` | 刷新文件树 |
| **标签页** | `tn` / `tk` / `tj` / `to` | 新建 / 下 / 上 / 仅留当前 |
| **窗口** | `<C-h/j/k/l>` | 窗口间导航 |
| | `<A-h/j/k/l>` | 窗口大小调整 |
| **搜索** | `<leader>ff` | 文件搜索 |
| | `<leader>fg` | 文本搜索（grep） |
| | `<leader>fb` | buffer 列表 |
| | `<leader>fh` | 帮助标签搜索 |
| **LSP** | `gd` | 跳转到定义 |
| | `gD` | 跳转到声明 |
| | `K` | 悬浮文档 |
| | `gh` | 引用列表 |
| | `gr` | 重命名 |
| | `ga` | 代码操作 |
| | `gs` | 签名帮助 |
| | `go` | Trouble 符号大纲 |
| | `gt` | 诊断开关 |
| | `g[` / `g]` | 上/下一个诊断 |
| **Git** | `]g` / `[g` | 下/上一个 hunk |
| | `<leader>gs` | 暂存 hunk |
| | `<leader>gr` | 重置 hunk |
| | `<leader>gb` | blame |
| | `<leader>gB` | blame（预览） |
| | `gps` | git push |
| | `gpl` | git pull |
| **AI** | `<leader>cc` | 打开 AI 聊天 |
| | `<leader>ci` | AI 内联助手 |
| | `<leader>ca` | 当前文件添加到聊天上下文 |
| **运行/调试** | `<leader>r` | 运行当前文件（底部面板） |
| | `<F5>` | 切换终端 |
| | `<F6>`..`<F11>` | DAP 调试控制 |
| **文本操作** | `jk` / `kj` | 退出插入模式 |
| | `<Esc>` | 清除搜索高亮 |
| | `Y` | 复制到行尾 |
| | `gc` | 注释切换 |
| | `<leader>m` | 拆分/合并代码 |
| | `<leader>;` | 面包屑导航 |
| | `<leader>w` | Hop 单词跳转 |
| | `<leader>S` | Flash 快速跳转 |
| **包管理** | `<leader>ph..px` | lazy.nvim 面板/同步/更新等 |
| **会话** | `<leader>ss` | 保存会话 |
| | `<leader>sl` | Telescope 会话列表 |
| **格式化** | `<A-f>` | 切换保存时格式化 |
| | `<A-S-f>` | 手动格式化 |

### 工具链

| 命令 | 替代 | 功能 |
|------|------|------|
| `eza` | `ls` | 彩色目录列表，git 状态，树形结构 |
| `bat` | `cat` | 语法高亮文件预览，Git 集成 |
| `rg` | `grep` | 递归文本搜索，.gitignore 感知 |
| `fd` | `find` | 文件搜索，.gitignore 感知 |
| `delta` | `diff` | Git diff 语法高亮分页器 |
| `fzf` | — | 模糊搜索，集成 Ctrl+R / Ctrl+T / Alt+C |
| `zoxide` | `cd` | 智能目录跳转（`z` / `zi` / `za`） |
| `atuin` | `history` | shell 历史模糊搜索 + 加密同步 |
| `btop` | `top` | 系统监控（CPU / 内存 / 磁盘 / GPU） |
| `lazygit` | — | Git TUI |
| `zellij` | `tmux` | 终端多路复用器 |
| `yazi` | — | 终端文件管理器 |
| `mise` | `pyenv`/`nvm`/`rbenv` | 统一运行时版本管理 |
| `carapace` | — | Shell 补全 |
| `fastfetch` | `neofetch` | 系统信息 |
| `just` | `make` | 任务编排 |

## 部署

```bash
git clone git@github.com:1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 建立 symlink（configure 会自动调用 stow）
./configure link

# 安装系统包
brew bundle --file .Brewfile

# 安装 Zim 模块
zimfw install

# 安装运行时（Python / Node / Go / Rust 等）
mise install

# 重开终端
exec zsh

# 验证所有 symlink 正常
./configure doctor
```

首次启动 Neovim 会自动执行 `:Lazy! sync` 安装全部插件。

## 特色

- **全栈覆盖** — 从终端模拟器到编辑器、版本控制、容器化、AI 辅助，统一管理和维护
- **一致视觉** — 所有组件配置 Tokyo Night Storm 配色
- **声明式管理** — 一个 `configure link` + `brew bundle` 部署完整环境
- **快捷键体系** — 分类命名、中文提示，which-key 引导无需记忆
- **AI 原生** — 免费 AI 补全（Supermaven）和任意模型聊天（CodeCompanion + OpenRouter）
- **XDG 规范** — 所有缓存、配置、数据目录遵循 XDG 标准
- **安全性** — API 密钥由用户自行配置环境变量，不写入代码仓库
- **模块化** — 每个组件独立目录，按需选择，易于扩展

## 依赖

- macOS（测试于 Apple Silicon）
- [Homebrew](https://brew.sh)
- Git
- [Nerd Font](https://www.nerdfonts.com)（推荐 Maple Mono NF）

## License

MIT
