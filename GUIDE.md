# 终端配置使用指南

> **Zsh + Zimfw + Kitty + tmux + Tokyo Night Storm**
> 更新日期: 2026-04-28

---

## 目录

- [第一章 架构总览](#第一章-架构总览)
- [第二章 Shell 配置](#第二章-shell-配置-zsh--zimfw)
- [第三章 Kitty 终端](#第三章-kitty-终端)
- [第四章 tmux](#第四章-tmux-终端复用)
- [第五章 现代 CLI 工具](#第五章-现代-cli-工具)
- [第六章 全部快捷键](#第六章-全部快捷键)
- [第七章 自定义函数](#第七章-自定义函数)
- [第八章 常见问题排查](#第八章-常见问题排查)

---

## 第一章 架构总览

你的终端技术栈由以下层级组成：

| 层级 | 工具 | 作用 |
|---|---|---|
| 终端模拟器 | Kitty | GPU 加速、毛玻璃效果、Tokyo Night 主题 |
| 终端复用 | tmux | 会话管理、Vim 风格快捷键 |
| Shell | Zsh 5.9 | 交互式 Shell，基于 Zimfw 框架 |
| 框架 | Zimfw | 模块管理（替代 oh-my-zsh） |
| 提示符 | Powerlevel10k | Pure 风格、即时提示、Git 状态 |
| 补全 | zsh-completions | 增强的 Tab 补全 |
| 语法高亮 | zsh-syntax-highlighting | Tokyo Night 配色方案 |
| 自动建议 | zsh-autosuggestions | 历史 + 补全的灰色建议 |
| 智能缩写 | zsh-abbr | 空格触发展开的缩写 |
| 模糊搜索 | fzf | Ctrl+R 历史、Ctrl+T 文件、Alt+C 目录 |
| 目录跳转 | zoxide | 智能 cd，学习你的习惯 |
| 文件列表 | eza | 现代 ls，带图标和 Git 状态 |
| 文件查看 | bat | 语法高亮 + 行号 |
| 系统监控 | btop | 资源监控（替代 top/htop） |
| 系统信息 | fastfetch | 启动时显示系统信息 |

---

## 第二章 Shell 配置 (Zsh + Zimfw)

### 2.1 配置文件说明

| 文件 | 用途 | 加载顺序 |
|---|---|---|
| `.zshenv` | 环境变量（cargo） | 第 1 — 始终加载 |
| `.zprofile` | Homebrew 镜像 + shellenv | 第 2 — 仅登录 Shell |
| `.zshrc` | 主配置（别名、函数等） | 第 3 — 交互式 Shell |
| `.zimrc` | Zimfw 模块列表 | Zimfw 初始化时读取 |
| `.p10k.zsh` | Powerlevel10k 提示符配置 | .zshrc 末尾加载 |

### 2.2 Zimfw 模块

| 模块 | 功能 |
|---|---|
| environment | 默认环境变量 |
| input | 键盘输入配置 |
| utility | 实用 Shell 工具函数 |
| termtitle | 终端标题栏 |
| zsh-completions | 额外补全（docker、npm 等） |
| completion | Tab 补全引擎 |
| archive | 解压补全（tar、zip、rar 等） |
| zsh-syntax-highlighting | 命令语法着色 |
| zsh-autosuggestions | 灰色建议文本 |
| git | Git 别名和函数 |
| ssh | SSH 主机名补全 |
| ruby | Ruby 补全 |
| zsh-abbr | 智能缩写展开 |
| powerlevel10k | 提示符主题 |

### 2.3 历史记录配置

| 设置 | 值 | 说明 |
|---|---|---|
| HISTFILE | ~/.zsh_history | 历史文件位置 |
| HISTSIZE | 100,000 | 内存中保留的行数 |
| SAVEHIST | 100,000 | 写入磁盘的行数 |
| HIST_IGNORE_ALL_DUPS | 开启 | 去除重复命令 |
| HIST_IGNORE_SPACE | 开启 | 空格开头的命令不记录 |
| SHARE_HISTORY | 开启 | 多终端共享历史 |
| INC_APPEND_HISTORY | 开启 | 即时追加（无需等待） |
| EXTENDED_HISTORY | 开启 | 记录时间戳 |

> 💡 **小技巧**：在命令前加一个空格即可不记录到历史，例如` secret-command`

### 2.4 语法高亮配色 (Tokyo Night)

| 元素 | 颜色 | 样式 |
|---|---|---|
| 命令 / 函数 | #9ece6a (绿色) | 加粗 |
| 内置命令 | #7dcfff (青色) | 普通 |
| 路径 | #7aa2f7 (蓝色) | 下划线 |
| 字符串 / 参数 | #e0af68 (黄色) | 普通 |
| 错误 | #f7768e (红色) | 加粗 |
| 注释 | #565f89 (灰色) | 斜体 |
| 通配符 / 历史展开 | #7aa2f7 (蓝色) | 加粗 |

---

## 第三章 Kitty 终端

### 3.1 视觉设置

| 设置项 | 值 | 效果 |
|---|---|---|
| 主题 | Tokyo Night Storm | 深蓝紫色调 |
| 字体 | FiraCode Nerd Font 14pt | 编程字体 + 图标 |
| 背景透明度 | 0.4 | 高度透明 |
| 背景模糊 | 80 | 强毛玻璃效果 |
| 窗口内边距 | 16 x 8 | 内容周围留白 |
| 光标 | Beam (1.5px) | 细垂直线，不闪烁 |
| Tab 栏 | 底部 Powerline 斜体 | 现代 Tab 风格 |
| 初始大小 | 140 列 x 40 行 | 默认窗口大小 |

### 3.2 Kitty 全部快捷键

| 快捷键 | 功能 |
|---|---|
| `Cmd + T` | 新建 Tab |
| `Cmd + W` | 关闭 Tab |
| `Cmd + 1-9` | 切换到 Tab 1-9 |
| `Cmd + Shift + [ / ]` | 左右移动 Tab |
| `Cmd + N` | 新建窗口 |
| `Cmd + Enter` | 切换全屏 |
| `Cmd + D` | 垂直分屏（左右） |
| `Cmd + Shift + D` | 水平分屏（上下） |
| `Ctrl + H/J/K/L` | 在分屏间导航 |
| `Ctrl + Shift + H/J/K/L` | 调整分屏大小 |
| `Cmd + C / V` | 复制 / 粘贴 |
| `Cmd + = / - / 0` | 字体放大 / 缩小 / 重置 |
| `Cmd + Shift + A > M` | 增加透明度 (+0.05) |
| `Cmd + Shift + A > L` | 减少透明度 (-0.05) |
| `Cmd + Shift + A > D` | 重置透明度 |
| `Cmd + ,` | 编辑 kitty.conf |
| `Cmd + Shift + ,` | 重新加载 kitty.conf |
| `Cmd + Shift + F` | fzf 覆盖层（模糊搜索文件） |
| `Cmd + Shift + G` | 启动 lazygit |
| `Cmd + Shift + J` | 启动 joshuto（文件管理器） |
| `Cmd + Shift + B` | 启动 btop（覆盖层） |

### 3.3 性能优化

| 设置 | 值 | 说明 |
|---|---|---|
| repaint_delay | 3ms | 最低输入到屏幕延迟 |
| input_delay | 1ms | 接近即时的按键响应 |
| opengl_backend | auto | Metal GPU 渲染 |
| sync_to_monitor | yes | 开启垂直同步 |

---

## 第四章 tmux 终端复用

### 4.1 基础设置

| 设置 | 值 |
|---|---|
| 前缀键 | `Ctrl + A`（替代默认的 Ctrl + B） |
| Escape 延迟 | 0ms（无延迟） |
| 历史行数 | 50,000 行 |
| 编号起始 | 1（窗口和面板从 1 开始） |
| 鼠标 | 已启用 |
| 复制模式 | Vi 风格（hjkl 导航） |

### 4.2 tmux 全部快捷键

> 以下快捷键均需先按前缀键 Prefix (`Ctrl+A`)：

| 按键 | 功能 |
|---|---|
| `Prefix + v` | 垂直分屏（左右） |
| `Prefix + s` | 水平分屏（上下） |
| `Prefix + h/j/k/l` | 在面板间导航 |
| `Prefix + H/J/K/L` | 调整面板大小（可重复） |
| `Prefix + c` | 新建窗口 |
| `Prefix + n / p` | 下一个 / 上一个窗口 |
| `Prefix + 1-5` | 切换到窗口 1-5 |
| `Prefix + r` | 重新加载配置 |
| `Prefix + [` | 进入复制模式 |
| 复制模式: `v` | 开始选择 |
| 复制模式: `y` | 复制选中内容到剪贴板 |
| 复制模式: `C-v` | 矩形选择切换 |

### 4.3 tmux 插件 (TPM)

| 插件 | 功能 |
|---|---|
| tmux-sensible | 合理的默认配置 |
| tmux-pain-control | Vim 风格的面板管理 |
| tmux-prefix-highlight | 显示前缀键激活状态 |
| tmux-yank | 跨平台剪贴板支持 |
| tmux-resurrect | 保存/恢复 tmux 会话 |

> 💡 安装插件: `Prefix + I` | 更新插件: `Prefix + U`

### 4.4 快速会话管理

使用 `t()` 函数快速管理 tmux 会话：

```bash
t            # 创建或附加到会话 'main'
t work       # 创建或附加到会话 'work'
t dev        # 创建或附加到会话 'dev'
```

---

## 第五章 现代 CLI 工具

### 5.1 核心替代工具

| 旧命令 | 新命令 | 别名 | 主要特点 |
|---|---|---|---|
| ls | eza | `ls` | 图标、Git 状态、树形视图 |
| cat | bat | `cat` | 语法高亮、行号 |
| top/htop | btop | `top` | GPU 监控、美丽 UI |
| cd (模糊) | zoxide | `z` | 学习你的习惯 |
| grep | ripgrep | `grep` | 极快，自动尊重 .gitignore |
| diff | delta | `diff` | 并排对比，语法着色 |
| man | bat + col | `man` | 语法高亮的 man 页面 |

### 5.2 eza (现代 ls)

| 别名 | 实际命令 | 说明 |
|---|---|---|
| `ls` | `eza --icons --group-directories-first` | 带图标的基本列表 |
| `ll` | `eza -la --icons --group-directories-first --git` | 详细 + Git 状态 |
| `la` | `eza -a --icons --group-directories-first` | 显示隐藏文件 |
| `lt` | `eza --tree --icons --level=3 --git` | 树形视图（3 层） |
| `ld` | `eza -la --icons --group-directories-first --git --sort=modified` | 按修改时间排序 |

### 5.3 bat (现代 cat)

| 别名 | 实际命令 | 说明 |
|---|---|---|
| `cat` | `bat --paging=never` | 无分页（类似原始 cat） |
| `catp` | `bat` | 带分页（适合长文件） |

> 💡 主题: TokyoNight Storm（与终端自动匹配）
> 💡 man 页面也通过 bat 渲染（MANPAGER）

### 5.4 fzf (模糊搜索)

fzf 深度集成到你的工作流中：

| 快捷键 | 功能 | 预览 |
|---|---|---|
| `Ctrl + R` | 搜索命令历史 | 显示命令内容 |
| `Ctrl + T` | 模糊搜索并插入文件路径 | bat 预览 |
| `Alt + C` | 模糊搜索并 cd 到目录 | eza 树形视图 |

**Ctrl+R 增强功能：**

| 快捷键 | 功能 |
|---|---|
| `Ctrl + Y` | 复制选中的命令到剪贴板 |
| `Ctrl + /` | 切换预览窗口 |
| `Ctrl + A` | 全选 |

### 5.5 zoxide (智能 cd)

zoxide 会学习你的目录习惯，用得越多越智能。

| 命令 | 说明 |
|---|---|
| `z <关键词>` | 跳转到最匹配的目录 |
| `z -i <关键词>` | 交互式选择（通过 fzf） |
| `z -b .` | 从当前目录跳转（局部） |

### 5.6 zsh-abbr (智能缩写)

缩写在按空格时自动展开。与 alias 不同，它会先显示展开后的命令再执行。

**使用方法：**

```bash
abbr -a gcm 'git commit -m'    # 定义缩写
gcm fix typo                   # 输入缩写，按空格
# -> git commit -m fix typo    # 自动展开!
```

**管理缩写：**

```bash
abbr -g                        # 列出全局缩写
abbr -g <名称> '<展开>'        # 设置全局缩写
abbr -r <名称>                 # 删除缩写
```

### 5.7 其他工具

| 工具 | 别名 | 启动命令 | 说明 |
|---|---|---|---|
| lazygit | `lg` | `lg` | 终端 UI 的 Git 客户端 |
| joshuto | `josh` | `josh` | Ranger 风格的文件管理器 |
| btop | `bt` | `bt` | 系统资源监控 |
| tldr | `tldr` | `tldr <命令>` | 简明版 man 页面 |

---

## 第六章 全部快捷键

### 6.1 Zsh 行编辑

| 快捷键 | 功能 |
|---|---|
| `Ctrl + A` | 跳到行首 |
| `Ctrl + E` | 跳到行尾 |
| `Alt + F` | 向前跳一个单词 |
| `Alt + B` | 向后跳一个单词 |
| `Ctrl + U` | 删除光标到行首 |
| `Ctrl + K` | 删除光标到行尾 |
| `Ctrl + W` | 删除前一个单词 |
| `Alt + Backspace` | 删除前一个单词 |
| `Ctrl + _` | 撤销 |
| `Ctrl + X, Ctrl + R` | 重做 |
| `↑ / ↓` | 搜索历史（匹配当前输入） |

### 6.2 目录导航

| 命令 | 功能 |
|---|---|
| `..` | cd .. |
| `...` | cd ../.. |
| `....` | cd ../../.. |
| `cd -` | 返回上一个目录 |
| 直接输入目录名 | 直接 cd（无需输入 cd） |
| `z <关键词>` | zoxide 智能跳转 |
| `fzd` | 模糊搜索目录并 cd |

### 6.3 Git 快捷键

| 别名 | 完整命令 |
|---|---|
| `gs` | `git status` |
| `ga / gaa` | `git add / git add --all` |
| `gc / gcm` | `git commit / git commit -m` |
| `gp / gpl` | `git push / git pull` |
| `gd / gds` | `git diff / git diff --staged` |
| `gco / gcb` | `git checkout / git checkout -b` |
| `gb` | `git branch` |
| `glog` | `git log --oneline --graph --decorate --all` |
| `gst / gstp / gstl` | `git stash / pop / list` |
| `gpr` | `git pull --rebase` |
| `gsync` | `git fetch && git rebase` |
| `gclean` | `git clean -fd` |

### 6.4 Docker 快捷键

| 别名 | 完整命令 |
|---|---|
| `d / dc` | `docker / docker compose` |
| `dps / dpsa` | `docker ps / docker ps -a` |
| `di` | `docker images` |
| `drm / drmi` | `docker rm / docker rmi` |
| `dstop` | `docker stop $(docker ps -q)` |
| `dprune` | `docker system prune -af` |

### 6.5 系统快捷键

| 别名 | 完整命令 |
|---|---|
| `c` | `clear` |
| `h` | `history` |
| `ports` | `lsof -iTCP -sTCP:LISTEN -n -P` |
| `port <名称>` | `lsof ... \| grep <名称>` |
| `myip` | `curl -s ifconfig.me` |
| `localip` | `ipconfig getifaddr en0` |
| `path` | 打印 PATH（每行一个） |
| `reload` | `source ~/.zshrc` |
| `brewup` | `brew update && brew upgrade && brew cleanup` |

### 6.6 配置文件快捷方式

| 别名 | 打开 |
|---|---|
| `zshconfig` | `nvim ~/.zshrc` |
| `p10kconfig` | `nvim ~/.p10k.zsh` |
| `kittyconfig` | `nvim ~/.config/kitty/kitty.conf` |
| `tmuxconfig` | `nvim ~/.config/tmux/tmux.conf` |

---

## 第七章 自定义函数

### 7.1 目录与文件函数

| 函数 | 用法 | 说明 |
|---|---|---|
| `mkcd` | `mkcd <目录>` | 创建目录并进入 |
| `take` | `take <目录>` | 同 mkcd（更短） |
| `ff` | `ff <名称>` | 按名称查找文件（忽略大小写） |
| `fo` | `fo` | 模糊搜索文件并在 nvim 中打开 |
| `gr` | `gr` | cd 到 Git 仓库根目录 |
| `extract` | `extract <文件>` | 智能解压（tar、zip、rar、7z 等） |

**支持的解压格式：**
tar.gz, tar.bz2, tar.xz, tar, zip, gz, bz2, xz, lz4, zst, rar, 7z, Z, deb

### 7.2 Git 函数

| 函数 | 用法 | 说明 |
|---|---|---|
| `gacf` | `gacf '提交信息'` | 交互式 Git 提交（fzf 选择文件） |

### 7.3 实用工具函数

| 函数 | 用法 | 说明 |
|---|---|---|
| `t` | `t [名称]` | tmux 会话管理（自动创建/附加） |
| `note` | `note [名称]` | 快速笔记（默认今天日期） |
| `weather` | `weather [城市]` | 查看天气（默认中文） |
| `port` | `port <名称>` | 查找监听端口的进程 |
| `ipinfo` | `ipinfo [IP]` | IP 地理位置信息 |

---

## 第八章 常见问题排查

### 8.1 常见问题解决

| 问题 | 解决方案 |
|---|---|
| 提示符加载很慢 | 执行: `rm -rf ~/.zim && zimfw install` |
| gitstatus 报错 | 执行: `rm -rf ~/.zim && zimfw install` |
| autosuggestions 报错 | 检查 .zshrc 中 `ZSH_AUTOSUGGEST_STRATEGY` |
| fzf compinit 警告 | 已修复（使用 key-bindings.zsh） |
| Kitty 透明不生效 | 确保系统设置 > 桌面 > 允许壁纸着色 |
| tmux 颜色异常 | 确保 `TERM=xterm-256color` 和 `:RGB` 覆盖 |
| Powerlevel10k 图标乱码 | 确保安装了 FiraCode Nerd Font |

### 8.2 全部重置

如果配置完全崩溃，执行以下命令重置：

```bash
rm -rf ~/.zim ~/.zsh/cache
zimfw install
exec zsh
```

### 8.3 重新配置 Powerlevel10k

```bash
p10k configure
```

这会启动交互式向导重新配置提示符。

### 8.4 更新所有工具

```bash
brewup                  # 更新 Homebrew + 升级 + 清理
zimfw update            # 更新 Zimfw 模块
tmux plugin update      # 更新 tmux 插件 (Prefix + U)
```

---

> **— 终端配置使用指南 完 —**
