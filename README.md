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
├── mise/          .config/mise/config.toml
├── npm/           .npmrc
├── pip/           .config/pip/pip.conf
├── brew/          .Brewfile
├── cheatsheet/    ai-dev-cheatsheet.md
├── docker/        docker-compose-ai.yml + litellm_config.yaml
├── configure       — 部署脚本
└── justfile        — 任务编排
```

### 配置文件说明

#### Shell 环境 (`zsh/`, `zim/`, `p10k/`)

- **`.zshenv`** — 所有 Shell 共享环境变量（PATH、cargo、编辑器变量）
- **`.zprofile`** — 登录 Shell 初始化（Homebrew、包管理器）
- **`.zshrc`** — 交互式 Shell 配置（Zimfw 加载、工具链别名、fzf 键位、补全、atuin 历史、zoxide 目录跳转、Powerlevel10k 提示符、代理检测）
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

- **mise** (`mise/.config/mise/config.toml`) — 运行时版本管理
  - 当前管理 Node 22 + Python 3.12
  - `mise install` 一键安装

- **npm** (`npm/.npmrc`) — Node.js 包管理
  - npmmirror 镜像源

- **pip** (`pip/.config/pip/pip.conf`) — Python 包管理
  - 清华镜像源

#### 容器化

- **Docker** (`docker/docker-compose-ai.yml`) — AI 服务栈
  - ChromaDB（向量数据库）
  - Qdrant（向量数据库，备选）
  - pgvector（PostgreSQL 向量扩展）
  - LiteLLM（OpenAI 兼容 API 代理，路由到 Ollama + OpenRouter）
  - Ollama 由 `just ollama` 在宿主机直接运行

### Neovim 配置

基于 lazy.nvim，54 个插件，按功能模块划分。

#### 核心插件加载 (`init.lua`)

- **lazy.nvim** — 插件管理器，并行安装、按需加载、内置 UI

#### 文件管理

| 插件 | 用途 |
|------|------|
| snacks.nvim (explorer) | 文件树浏览器 |
| oil.nvim | 默认文件管理器（替代 NetRW，`-` 键打开） |
| edgy.nvim | 可编程侧边栏布局（左：Trouble，底：终端 + 问题列表 + 帮助） |

#### 搜索

| 插件 | 用途 |
|------|------|
| snacks.nvim (picker) | 模糊搜索框架（内置 Rust 模糊匹配，替代 telescope） |

#### 补全与片段

| 插件 | 用途 |
|------|------|
| blink.cmp | 补全引擎（LSP + 路径 + 片段 + buffer） |
| LuaSnip | 代码片段引擎 |
| friendly-snippets | 预置代码片段库 |

#### LSP 与格式化

| 插件 | 用途 |
|------|------|
| mason.nvim | LSP / DAP / linter / formatter 安装管理 |
| mason-lspconfig.nvim | mason ↔ lspconfig 桥接 |
| nvim-lspconfig | LSP 客户端配置 |
| conform.nvim | 代码格式化（保存时自动 / 手动触发） |
| trouble.nvim | LSP 诊断 / 引用 / 符号列表 |

支持的语言和 LSP 服务器：bashls / gopls / lua_ls / pyright / ruff / rust_analyzer / ts_ls

#### AI 辅助

| 插件 | 用途 |
|------|------|
| avante.nvim | AI 聊天 + 内联编辑，支持 OpenRouter 任意模型 |
| supermaven-nvim | AI 行内代码补全（`<C-y>` 接受，`<C-]>` 取消，`<C-j>` 接受单词） |
| im-select.nvim | 退出插入模式自动切换英文输入法，解决中英混输问题 |

Avante 使用 `OPENROUTER_API_KEY`，提供对话、内联编辑等功能；行内补全由 supermaven-nvim 提供。

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
| snacks.nvim (notifier) | 通知 + LSP 进度 |
| mini.nvim (icons) | 文件类型图标（替代 nvim-web-devicons） |
| which-key.nvim | 快捷键弹出引导 |

#### 编辑器增强

| 插件 | 用途 |
|------|------|
| nvim-treesitter | 语法树高亮 + 增量解析 |
| nvim-treesitter-textobjects | 结构化文本对象（function/class/block 内/外选择、移动） |
| treesj | 代码行拆分/合并 |
| grug-far.nvim | 项目范围搜索替换（支持 ripgrep） |
| im-select.nvim | 退出插入模式自动切回英文输入法，避免中文输入干扰 Vim 模式 |
| comment.nvim | 代码注释（`gc` / `gcc`） |
| nvim-autopairs | 括号自动补全 |
| flash.nvim | Treesitter 感知的快速跳转（单词/行/双字符） |
| persisted.nvim | 会话自动保存/恢复 |
| nvim-bufdel | 安全关闭 buffer（保留窗口布局） |
| smart-splits.nvim | 窗口间智能导航与调整 |
| smear-cursor.nvim | 光标平滑动画 |
| colorizer.lua | 颜色代码高亮预览 |
| snacks.nvim (indent) | 缩进指示线（替代 indent-blankline） |
| dressing.nvim | 内置 UI（vim.ui.input/select）美化 |
| mini.nvim | 模块化工具集：文本对象增强 (ai)、环绕编辑 (surround)、图标 (icons)、注释 (comment) |
| todo-comments.nvim | TODO/FIXME/HACK 高亮与搜索 |
| undotree | 可视化撤销树 |
| toggleterm.nvim | 浮动/底部终端面板 |
| render-markdown.nvim | Markdown 实时渲染 |
| markdown-preview.nvim | Markdown 浏览器预览（F12） |

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
| | `<leader>fb` | buffer 列表 |
| | `<leader>bn` / `bp` / `bd` | 下一个 / 上一个 / 关闭 |
| **文件管理** | `<leader>n` | snacks 文件树 |
| | `-` | Oil 文件管理器（替代 NetRW） |
| **标签页** | `<leader>tn` / `th` / `tl` | 新建 / 左 / 右 |
| | `<leader>tc` / `to` | 关闭 / 仅留当前 |
| | `<leader>t1`..`<leader>t9` | 跳转到标签 1~9 |
| **窗口** | `<C-h/j/k/l>` | 窗口间导航 |
| | `<A-h/j/k/l>` | 窗口大小调整 |
| | `<leader>W` | 窗口导航（替代） |
| **搜索** | `<leader>ff` | 文件搜索 |
| | `<leader>fg` | 文本搜索（grep） |
| | `<leader>fb` | buffer 列表 |
| | `<leader>fh` | 帮助标签搜索 |
| | `<leader>fr` | 恢复上次搜索 |
| | `<leader>fp` | 当前目录文件搜索 |
| | `<leader>f.` | 最近文件 |
| | `<C-p>` | 命令面板 |
| **搜索替换** | `<leader>Sr` | 项目搜索替换（GrugFar） |
| | `<leader>Sw` | 替换当前词 |
| **LSP** | `gd` | 跳转到定义 |
| | `gD` | 跳转到声明 |
| | `gi` | 查找实现 |
| | `K` | 悬浮文档 |
| | `gh` | 引用列表 |
| | `gr` | 重命名 |
| | `ga` | 代码操作 |
| | `gs` | 签名帮助 |
| | `go` | Trouble 符号大纲 |
| | `gt` | Trouble 诊断开关 |
| | `g[` / `g]` | 上/下一个诊断 |
| **Git** | `]g` / `[g` | 下/上一个 hunk |
| | `<leader>gs` | 暂存 hunk |
| | `<leader>gr` | 重置 hunk |
| | `<leader>gR` | 重置整个缓冲区 |
| | `<leader>gp` | 预览 hunk |
| | `<leader>gb` | blame |
| | `<leader>gB` | 切换行内 blame |
| | `<leader>gd` | Diffview 打开 |
| | `<leader>gD` | Diffview 关闭 |
| | `<leader>gG` | Git 面板 |
| | `<leader>gP` | git push |
| | `<leader>gl` | git pull |
| **AI** | `<leader>aa` | Avante 对话 |
| | `<leader>ae` | Avante 编辑选区（可视模式） |
| | `<leader>am` | 选择模型 |
| | `<leader>at` | 切换侧边栏 |
| | `<C-y>` | Supermaven 接受补全 |
| **运行/调试** | `<leader>r` | 运行当前文件（底部面板） |
| | `<A-d>` | 浮动终端 |
| | `<C-\>` | 切换终端 |
| | `<F6>`..`<F11>` | DAP 调试控制 |
| | `<leader>dc/b/dB/do/di/dO/dt/dr` | DAP 操作别名 |
| **测试** | `<leader>tf` | 运行当前文件测试 |
| | `<leader>tN` | 运行最近测试 |
| | `<leader>tO` | 测试输出 |
| | `<leader>ts` | 测试汇总 |
| **文本操作** | `jk` / `kj` | 退出插入模式 |
| | `<leader>h` | 清除搜索高亮 |
| | `<leader>rr` | 屏幕重绘 |
| | `Y` | 复制到行尾 |
| | `gc` | 注释切换 |
| | `<leader>m` | 拆分/合并代码 |
| | `<leader>u` | 撤销树 |
| | `<leader>j` | Flash 单词跳转 |
| | `<leader>k` | Flash 语法跳转 |
| **包管理** | `<leader>ph..px` | lazy.nvim 面板/同步/更新等 |
| **会话** | `<leader>ss` | 保存会话 |
| | `<leader>sl` | 加载会话 |
| | `<leader>sd` | 删除会话 |
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
brew bundle --file brew/.Brewfile

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
- **uv 优先** — Python 包管理首选 uv，`ai` 别名快速激活 AI 虚拟环境
- **AI 原生** — Avante.nvim 全功能 AI 助手（对话 + 内联编辑 + 自动建议），支持 OpenRouter 任意模型
- **XDG 规范** — 所有缓存、配置、数据目录遵循 XDG 标准
## 依赖

- macOS（测试于 Apple Silicon）
- [Homebrew](https://brew.sh)
- Git
- [Nerd Font](https://www.nerdfonts.com)（推荐 Maple Mono NF）

## License

MIT
