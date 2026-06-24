# macOS 开发环境速查手册

> macOS Apple Silicon · Ghostty · Zsh + Zim + p10k · Neovim · Tokyo Night Storm

---

## 目录

1. [Shell 相关](#1-shell-相关)
2. [Neovim 快捷键](#2-neovim-快捷键)
3. [Git](#3-git)
4. [包管理](#4-包管理)
5. [AI 开发](#5-ai-开发)
6. [Docker 与 AI 基础设施](#6-docker-与-ai-基础设施)
7. [系统工具](#7-系统工具)
8. [常用快捷键](#8-常用快捷键)

---

## 1. Shell 相关

### 别名

| 命令 | 实际行为 |
|------|----------|
| `vim` / `vi` / `v` | `nvim` |
| `cat` / `catp` | `bat` |
| `ls` | `eza --icons --group-directories-first` |
| `ll` | `eza -la --icons --git` |
| `la` | `eza -a --icons` |
| `lt` | `eza --tree --icons --level=3` |
| `grep` | `rg` |
| `diff` | `delta` |
| `top` | `btop` |
| `ps` | `ps aux` |
| `ping` | `ping -c 5` |
| `..` / `...` / `....` | `cd ..` 多级 |
| `-` | `cd -` |
| `cp` / `mv` / `rm` | 加 `-iv` 交互确认 |
| `lg` | `lazygit` |
| `bt` | `btop` |
| `tldr` | 带颜色的简版 man |
| `ai` | source `~/.venvs/ai/bin/activate` |
| `asitop` | GPU 监控 |
| `ql` | Quick Look 预览文件 |
| `myip` | curl ifconfig.me |
| `localip` | `ipconfig getifaddr en0` |
| `reload` | `source ~/.zshrc` |
| `h` | `atuin history` |
| `hg` | `atuin search --interactive` |

#### Git 别名

| 别名 | 作用 |
|------|------|
| `gs` | status |
| `ga` / `gaa` | add / add --all |
| `gc` / `gcm` | commit / commit -m |
| `gp` / `gpl` | push / pull |
| `gd` / `gds` | diff / diff --staged |
| `gco` / `gcb` | checkout / checkout -b |
| `gb` | branch |
| `glog` / `glogp` | log --oneline --graph |
| `gst` / `gstp` / `gstl` | stash / pop / list |
| `gpr` | pull --rebase |
| `gsync` | fetch + rebase |

### 目录导航

| 命令 | 作用 |
|------|------|
| `z foo` | zoxide 智能跳转到匹配目录 |
| `zi foo` | zoxide 交互式 fzf 选择 |
| `za` | zoxide 返回之前目录 |
| `fzd` | fd + fzf 交互式选目录 |
| `gr` | 跳转到 git 仓库根目录 |
| `mkcd` / `take` | 创建并进入目录 |

### 模糊搜索 (fzf)

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+T` | 搜索文件 (预览内容) |
| `Ctrl+R` | 搜索历史 (Ctrl+Y 复制到剪贴板) |
| `Alt+C` | 搜索目录 (预览树形) |
| `Ctrl+D` / `Ctrl+U` | 预览翻页 |
| `Ctrl+A` | 全选 |
| `Ctrl+/` | 切换预览 |
| `fo` | fzf 查找文件后用 nvim 打开 |
| `gacf` | git add + commit (fzf 选文件) |

### Shell 历史 (atuin)

| 命令 | 作用 |
|------|------|
| `↑`/`↓` (atuin) | 搜索历史并直接回车执行 |
| `h` | 查看历史 |
| `hg` | 交互式历史搜索 |

### 中文帮助

| 命令 | 作用 |
|------|------|
| `cht <cmd>` | 在线示例（中文） |
| `cht <cmd> en` | 在线示例（英文） |
| `cman <cmd>` | 中文 man 手册 |
| `tldr <cmd>` | 精简帮助 |

### 自定义函数

| 函数 | 作用 |
|------|------|
| `weather [城市]` | 命令行天气 |
| `note [文件名]` | 快速笔记 (默认日期) |
| `port <关键词>` | 查找端口占用 |
| `ipinfo [IP]` | IP 信息查询 |
| `extract <文件>` | 智能解压 (支持 15+ 格式) |
| `t [会话名]` | zellij 快速会话管理 |
| `ff <关键词>` | 按文件名查找 |
| `gacf <提交信息>` | git 交互式提交 |

### 快速编辑配置文件

| 命令 | 作用 |
|------|------|
| `zshconfig` | nvim ~/.zshrc |
| `p10kconfig` | nvim ~/.p10k.zsh |
| `zellijconfig` | nvim ~/.config/zellij/config.kdl |

---

## 2. Neovim 快捷键

> `<Space>` = `mapleader`

### 窗口管理

| 按键 | 作用 |
|------|------|
| `Ctrl+H/J/K/L` | 窗口导航 (智能停边) |
| `Alt+H/J/K/L` | 调整窗口大小 |
| `<leader>WH/J/K/L` | 窗口移动 |

### 文件搜索 (snacks.picker)

| 按键 | 作用 |
|------|------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 (grep) |
| `<leader>fb` | 缓冲区列表 |
| `<leader>fh` | 帮助标签 |
| `<leader>fr` | 恢复上次搜索 |
| `<leader>fp` | 当前目录文件 |
| `<leader>f.` | 最近文件 |
| `Ctrl+P` | 命令面板 (keymaps) |

### 文件树

| 按键 | 作用 |
|------|------|
| `<leader>n` | 打开 snacks.explorer |
| `-` | oil.nvim 文件管理器 |

### Tab 标签 (Terminal tab)

| 按键 | 作用 |
|------|------|
| `<leader>tn` | 新建标签 |
| `<leader>th` / `<leader>tl` | 左/右标签 |
| `<leader>tc` | 关闭标签 |
| `<leader>to` | 只留当前 |
| `<leader>t1`~`<leader>t9` | 跳转到标签 1-9 |

### Buffer 导航

| 按键 | 作用 |
|------|------|
| `Tab` / `Shift+Tab` | 下一个/上一个 Buffer |
| `Alt+I` / `Alt+O` | 下一个/上一个 Buffer |
| `Alt+Q` | 关闭 Buffer |
| `Alt+1`~`Alt+9` | 跳转到 Buffer 1-9 |
| `Alt+Shift+I/O` | Buffer 右移/左移 |
| `<leader>bn` / `<leader>bp` | 下一个/上一个 |
| `<leader>bd` | 关闭 Buffer |

### 编辑器

| 按键 | 作用 |
|------|------|
| `<leader>h` | 清除搜索高亮 |
| `<leader>rr` | 屏幕重绘 |
| `Y` | 复制到行尾 |
| `n` / `N` | 下一个/上一个 + 居中 |
| `jk` / `kj` (插入模式) | 返回 Normal |

### LSP

| 按键 | 作用 |
|------|------|
| `gd` | 跳转定义 |
| `gD` | 跳转声明 |
| `K` | 悬浮文档 |
| `gi` | 查找实现 |
| `gh` | 查找引用 |
| `gr` | 重命名 |
| `ga` | 代码操作 (code action) |
| `gs` | 签名帮助 |
| `go` | 符号大纲 |
| `g[` / `g]` | 上一个/下一个诊断 |

### Git

| 按键 | 作用 |
|------|------|
| `<leader>gs` | 暂存 hunk |
| `<leader>gr` | 重置 hunk |
| `<leader>gR` | 重置 buffer |
| `<leader>gp` | 预览 hunk |
| `<leader>gb` | Blame 当前行 |
| `<leader>gB` | 切换行内 blame |
| `<leader>gd` | Diffview 打开 |
| `<leader>gD` | Diffview 关闭 |
| `<leader>gG` | Git 面板 (fugitive) |
| `<leader>gP` | Git Push |
| `<leader>gl` | Git Pull |
| `gt` | Trouble 诊断列表 |

### 测试 (neotest)

| 按键 | 作用 |
|------|------|
| `<leader>tf` | 运行文件测试 |
| `<leader>tN` | 运行最近测试 |
| `<leader>tO` | 测试输出面板 |
| `<leader>ts` | 测试汇总 |

### 调试 (DAP)

| 按键 | 作用 |
|------|------|
| `F6` / `<leader>dc` | 继续调试 |
| `F7` / `<leader>dt` | 停止调试 |
| `F8` / `<leader>db` | 切换断点 |
| `F9` / `<leader>di` | 步入 |
| `F10` / `<leader>do` | 步过 |
| `F11` / `<leader>dO` | 步出 |
| `<leader>dB` | 条件断点 |
| `<leader>dr` | 切换调试界面 |

### AI (Avante)

| 按键 | 作用 |
|------|------|
| `<leader>aa` | Avante 对话 |
| `<leader>am` | 选择模型 |
| `<leader>at` | 切换侧边栏 |
| `<leader>as` | 切换 fast/strong provider |
| `<leader>ae` (Visual 模式) | 编辑选区 |

### 快速跳转 (flash.nvim)

| 按键 | 作用 |
|------|------|
| `<leader>j` | 快速跳转 (输入标签) |
| `<leader>k` | Treesitter 语法跳转 |

### 代码操作

| 按键 | 作用 |
|------|------|
| `<leader>m` | 拆分/合并代码块 |
| `<leader>Sr` | 搜索替换 (grug-far) |
| `<leader>Sw` | 替换当前词 |
| `<leader>u` | 撤销历史树 |
| `<leader>an` | 参数交换 (下一个) |
| `<leader>ap` | 参数交换 (上一个) |

### 保存/退出/终端

| 按键 | 作用 |
|------|------|
| `Ctrl+S` (N/I 模式) | 保存 |
| `<leader>q` | 退出 |
| `<leader>Q` | 全部退出 |
| `Alt+D` | 浮动终端 |
| `<leader>tt` | 切换终端面板 |
| `Esc Esc` (终端模式) | 退出终端模式 |

### 格式化

| 按键 | 作用 |
|------|------|
| `Alt+F` | 切换保存时自动格式化 |
| `Alt+Shift+F` | 手动格式化 |

### 会话管理

| 按键 | 作用 |
|------|------|
| `<leader>ss` | 保存会话 |
| `<leader>sl` | 加载会话 |
| `<leader>sd` | 删除会话 |

### 诊断与符号

| 按键 | 作用 |
|------|------|
| `<leader>lw` | 诊断列表 |
| `<leader>lp` | 项目诊断 |
| `<leader>ld` | 当前文件诊断 |
| `<leader>xs` | 符号列表 |
| `<leader>xl` | 位置列表 |
| `<leader>xq` | 快速修复列表 |

### 包管理 (lazy.nvim)

| 按键 | 作用 |
|------|------|
| `<leader>ph` | 包管理面板 |
| `<leader>ps` | 同步 |
| `<leader>pu` | 更新 |
| `<leader>pi` | 安装 |
| `<leader>pl` | 日志 |
| `<leader>pc` | 检查 |
| `<leader>pp` | 性能分析 |
| `<leader>pr` | 恢复 |
| `<leader>px` | 清理 |

### 运行代码

| 按键 | 作用 |
|------|------|
| `<leader>r` | 运行当前文件 (Python/Lua/Go/Rust/JS/TS/Bash/C/C++) |

---

## 3. Git

### Git 配置要点

| 项目 | 配置 |
|------|------|
| 用户名 | ryanzhu |
| 邮箱 | 1764712542@qq.com |
| 默认分支 | main |
| Pull 策略 | rebase |
| Pager | delta (TokyoNight 主题, 对比模式) |
| GitHub | SSH insteadOf HTTPS |
| 全局忽略 | `~/.gitignore_global` |

### 终端工具

| 命令 | 作用 |
|------|------|
| `lg` | lazygit (TUI) |
| `<leader>gG` | Neovim fugitive 面板 |
| `<leader>gd` | Diffview |
| `gsync` | git fetch + rebase |
| `gpr` | git pull --rebase |

---

## 4. 包管理

### Homebrew

| 命令 | 作用 |
|------|------|
| `brew install <pkg>` | 安装 formula |
| `brew install --cask <pkg>` | 安装应用 |
| `brew search <pkg>` | 搜索 |
| `brew update && brew upgrade` | 更新所有 |
| `brew cleanup` | 清理旧版本 |
| `brew autoremove` | 删除无用依赖 |
| `brew list` | 列出已安装 |
| `brew list --cask` | 列出已安装应用 |
| `brewup` | 一键 update + upgrade + cleanup |

### mise (运行时)

| 命令 | 作用 |
|------|------|
| `mise ls` | 查看已安装 |
| `mise install node@22` | 安装 Node |
| `mise use --global node@22` | 设为全局默认 |
| `mise upgrade` | 升级所有 |
| `mise upgrade node` | 升级 Node |

当前管理的运行时：**Node 22**, **Python 3.12**

### uv (Python)

| 命令 | 作用 |
|------|------|
| `uv pip install <pkg>` | 安装包 |
| `uv pip freeze` | 导出依赖 |
| `uv tool install <pkg>` | 安装工具 |
| `uv tool upgrade --all` | 升级所有工具 |
| `uv run <script>` | 临时运行 |

### 镜像源

| 工具 | 镜像 |
|------|------|
| Homebrew | USTC |
| pip | 清华 TUNA |
| npm | npmmirror |

---

## 5. AI 开发

### 虚拟环境

```bash
ai                              # source ~/.venvs/ai/bin/activate
```

### Justfile 任务

| 命令 | 作用 |
|------|------|
| `just activate` | 激活 AI 环境 |
| `just jupyter` | 启动 Jupyter Lab |
| `just ollama` | 启动 Ollama (需预先 `colima start`) |
| `just chroma` | 启动 ChromaDB |
| `just lmstudio` | 打开 LM Studio |
| `just update` | 更新 AI deps |
| `just freeze` | 冻结依赖到 requirements.txt |
| `just fix` | 一键格式化 (stylua + ruff + gofumpt + shfmt) |
| `just lint` | 运行 linter |
| `just update-all` | 全面更新 (brew + mise + uv) |
| `just clean` | 清理缓存 |
| `just doctor` | 检查环境健康 |
| `just gpu` | GPU 监控 |
| `just ane` | 查看 ANE 状态 |

### Neovim AI 配置

| 项目 | 配置 |
|------|------|
| Provider | OpenRouter (openrouter/owl-alpha) |
| 自动补全 | blink.cmp (LSP/path/snippets/buffer) |
| AI 行内补全 | supermaven-nvim (`<C-y>` 接受, `<C-]>` 取消) |
| Avante 侧边栏 | 快捷键 `<leader>aa` |
| 模型切换 | fast/strong (实际相同模型) |

---

## 6. Docker 与 AI 基础设施

### 启动

```bash
colima start                    # 启动 Docker 运行时
docker compose -f ~/dotfiles/docker/docker-compose-ai.yml up -d
```

### 服务

| 服务 | 端口 | 用途 |
|------|------|------|
| Ollama | 11434 | 本地 LLM |
| ChromaDB | 8000 | 向量数据库 |
| Qdrant | 6333 | 高性能向量库 (备选) |
| PGVector | 5432 | PostgreSQL 向量扩展 |
| LiteLLM | 4000 | OpenAI 兼容 API 代理 |

### Docker 别名

| 命令 | 作用 |
|------|------|
| `d` | docker |
| `dc` | docker compose |
| `dps` | docker ps |
| `dpsa` | docker ps -a |
| `di` | docker images |
| `drm` | docker rm |
| `drmi` | docker rmi |
| `dstop` | 停止所有容器 |
| `dprune` | 清理所有 |

---

## 7. 系统工具

| 工具 | 命令 | 用途 |
|------|------|------|
| **yazi** | `y` | 终端文件管理器 |
| **lazygit** | `lg` | Git TUI |
| **btop** | `bt` / `top` | 系统监控 |
| **fastfetch** | `fastfetch` | 系统信息 (启动时自动) |
| **asitop** | `asitop` | GPU 实时监控 |
| **zellij** | `zellij` | 终端复用器 (前缀键 `Ctrl+O`) |
| **gh** | `gh` | GitHub CLI |
| **k9s** | `k9s` | Kubernetes 管理 |
| **helmin** | `helm` | Kubernetes 包管理 |
| **terraform** | `terraform` | IaC 工具 |
| **glow** | `glow` | Markdown 渲染 |
| **httpie** | `http` | HTTP 客户端 (替代 curl) |
| **jq** / **yq** | `jq` / `yq` | JSON/YAML 处理 |
| **fd** | `fd` | 文件搜索 (替代 find) |
| **ripgrep** | `rg` | 内容搜索 (替代 grep) |
| **bat** | `bat` | 代码高亮 (替代 cat) |
| **eza** | `eza` | 文件列表 (替代 ls) |
| **delta** | `delta` | 对比 (替代 diff) |
| **tlrc** | `tlrc` / `tldr` | 精简命令帮助 |
| **stow** | `stow` | 点文件管理 |

---

## 8. 常用快捷键

### 终端 (Ghostty)

| 快捷键 | 作用 |
|--------|------|
| `Cmd+W` | 关闭标签 |
| `Cmd+T` | 新建标签 |
| `Cmd+数字` | 切换标签 |
| `Cmd+D` | 分屏 |
| `Cmd+Shift+D` | 关闭分屏 |
| `Cmd+点击` | 打开链接/文件 |

### Zellij (终端复用)

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+O` | 前缀键 |
| `Ctrl+O + D` | 分离会话 |
| `Ctrl+O + H/V` | 水平/垂直分屏 |
| `Ctrl+O + 方向键` | 切换面板 |
| `Ctrl+O + X` | 关闭面板 |
| `Ctrl+O + P` | 切换全屏 |
| `Ctrl+O + N` | 新建标签 |
| `Ctrl+O + Tab` | 切换标签 |

### Neovim (详见第 2 节)

| 核心快捷键 | 作用 |
|-----------|------|
| `jk` / `kj` | 退出插入模式 |
| `<Space>` | Leader 键 |
| `Ctrl+H/J/K/L` | 窗口导航 |
| `<Space>ff` | 找文件 |
| `<Space>fg` | 全文搜索 |
| `gd` | 跳转定义 |
| `<Space>aa` | AI 对话 |

### 系统

| 快捷键 | 作用 |
|--------|------|
| `Cmd+Space` | Raycast 启动器 |
| `Space` (选中文件) | Quick Look 预览 |
| `Cmd+Shift+.` | 显示隐藏文件 (Finder) |

---

> 最后更新: 2026-06-24
> 自动生成自 dotfiles 配置
