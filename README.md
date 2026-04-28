<div align="center">

# 🚀 macOS Dotfiles

**Zsh + Zimfw + Kitty + tmux + Tokyo Night Storm**

[English](#english) | [中文](#中文)

</div>

---

## 中文

### ✨ 特性

- 🎨 **统一 Tokyo Night Storm 主题** — Kitty、tmux、zsh 高亮、fzf、fastfetch 全局一致
- 🪟 **Kitty 毛玻璃效果** — 高透明度 + 强模糊的现代化终端
- ⚡ **Zimfw 框架** — 比 oh-my-zsh 更快的模块管理
- 🔥 **Powerlevel10k** — Pure 风格即时提示符，含 Git 状态
- 🔍 **fzf 深度集成** — Ctrl+R 历史、Ctrl+T 文件、Alt+C 目录
- 📁 **zoxide** — 智能目录跳转，学习你的习惯
- 🛠️ **现代 CLI 工具链** — eza、bat、ripgrep、delta、btop、fastfetch
- 📋 **tmux** — Vim 风格快捷键 + Tokyo Night 主题 + TPM 插件
- 🧠 **zsh-abbr** — 智能缩写展开（空格触发）
- 🍎 **macOS 深度适配** — Homebrew 中科大镜像、Apple Silicon Metal 渲染

### 📁 文件结构

```
dotfiles/
├── .zshrc                          # Zsh 主配置（别名、函数、环境变量）
├── .zshenv                         # 环境变量初始化
├── .zprofile                       # Homebrew 配置
├── .zimrc                          # Zimfw 模块列表
├── .p10k.zsh                       # Powerlevel10k 提示符配置
├── .gitconfig                      # Git 配置
├── config/
│   ├── kitty/
│   │   ├── kitty.conf              # Kitty 终端配置
│   │   └── themes/
│   │       └── tokyo_night_storm.conf  # Tokyo Night Storm 主题
│   ├── tmux/
│   │   └── tmux.conf               # tmux 配置
│   ├── btop/
│   │   └── btop.conf               # btop 系统监控配置
│   ├── fastfetch/
│   │   └── config.jsonc            # fastfetch 配置
│   └── neofetch/
│       └── config.conf             # neofetch 配置
└── GUIDE.md                        # 完整使用指南（中文）
```

### 📦 依赖

```bash
# 通过 Homebrew 安装
brew install zimfw zsh fzf zoxide eza bat ripgrep git-delta btop fastfetch lazygit joshuto tldr
brew install --cask kitty
```

### 🚀 安装

```bash
# 1. 克隆仓库
git clone https://github.com/ryanzhu/dotfiles.git ~/dotfiles

# 2. 备份现有配置
mkdir -p ~/.backup
mv ~/.zshrc ~/.zshenv ~/.zprofile ~/.zimrc ~/.p10k.zsh ~/.gitconfig ~/.backup/ 2>/dev/null
mv ~/.config/kitty ~/.config/tmux ~/.config/btop ~/.config/fastfetch ~/.config/neofetch ~/.backup/ 2>/dev/null

# 3. 创建符号链接
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zimrc ~/.zimrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/config/kitty ~/.config/kitty
ln -sf ~/dotfiles/config/tmux ~/.config/tmux
ln -sf ~/dotfiles/config/btop ~/.config/btop
ln -sf ~/dotfiles/config/fastfetch ~/.config/fastfetch
ln -sf ~/dotfiles/config/neofetch ~/.config/neofetch

# 4. 安装 Zimfw 模块
zimfw install

# 5. 重新打开终端
exec zsh
```

### 📖 使用指南

完整的使用指南请查看 [GUIDE.md](GUIDE.md)，包含：

- 🏗️ 架构总览
- 🐚 Shell 配置详解
- 🐱 Kitty 快捷键大全
- 📦 tmux 快捷键与插件
- 🛠️ 现代 CLI 工具用法
- ⌨️ 全部快捷键速查
- 📝 自定义函数说明
- 🔧 常见问题排查

### 📜 许可证

MIT License

---

## English

### ✨ Features

- 🎨 **Unified Tokyo Night Storm Theme** — Consistent across Kitty, tmux, zsh highlighting, fzf, fastfetch
- 🪟 **Kitty Glassmorphism** — High transparency + strong blur modern terminal
- ⚡ **Zimfw Framework** — Faster module management than oh-my-zsh
- 🔥 **Powerlevel10k** — Pure-style instant prompt with Git status
- 🔍 **Deep fzf Integration** — Ctrl+R history, Ctrl+T files, Alt+C directories
- 📁 **zoxide** — Smart directory jumping that learns your habits
- 🛠️ **Modern CLI Toolchain** — eza, bat, ripgrep, delta, btop, fastfetch
- 📋 **tmux** — Vim-style keybindings + Tokyo Night theme + TPM plugins
- 🧠 **zsh-abbr** — Smart abbreviations (expand on space)
- 🍎 **macOS Deep Integration** — Homebrew mirrors, Apple Silicon Metal rendering

### 📁 File Structure

```
dotfiles/
├── .zshrc                          # Main Zsh config (aliases, functions, env vars)
├── .zshenv                         # Environment variable initialization
├── .zprofile                       # Homebrew configuration
├── .zimrc                          # Zimfw module list
├── .p10k.zsh                       # Powerlevel10k prompt configuration
├── .gitconfig                      # Git configuration
├── config/
│   ├── kitty/
│   │   ├── kitty.conf              # Kitty terminal configuration
│   │   └── themes/
│   │       └── tokyo_night_storm.conf  # Tokyo Night Storm theme
│   ├── tmux/
│   │   └── tmux.conf               # tmux configuration
│   ├── btop/
│   │   └── btop.conf               # btop system monitor config
│   ├── fastfetch/
│   │   └── config.jsonc            # fastfetch configuration
│   └── neofetch/
│       └── config.conf             # neofetch configuration
└── GUIDE.md                        # Complete usage guide (Chinese)
```

### 📦 Dependencies

```bash
# Install via Homebrew
brew install zimfw zsh fzf zoxide eza bat ripgrep git-delta btop fastfetch lazygit joshuto tldr
brew install --cask kitty
```

### 🚀 Installation

```bash
# 1. Clone the repository
git clone https://github.com/ryanzhu/dotfiles.git ~/dotfiles

# 2. Backup existing configs
mkdir -p ~/.backup
mv ~/.zshrc ~/.zshenv ~/.zprofile ~/.zimrc ~/.p10k.zsh ~/.gitconfig ~/.backup/ 2>/dev/null
mv ~/.config/kitty ~/.config/tmux ~/.config/btop ~/.config/fastfetch ~/.config/neofetch ~/.backup/ 2>/dev/null

# 3. Create symlinks
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zimrc ~/.zimrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/config/kitty ~/.config/kitty
ln -sf ~/dotfiles/config/tmux ~/.config/tmux
ln -sf ~/dotfiles/config/btop ~/.config/btop
ln -sf ~/dotfiles/config/fastfetch ~/.config/fastfetch
ln -sf ~/dotfiles/config/neofetch ~/.config/neofetch

# 4. Install Zimfw modules
zimfw install

# 5. Restart terminal
exec zsh
```

### 📖 Usage Guide

See [GUIDE.md](GUIDE.md) for the complete usage guide covering:

- 🏗️ Architecture overview
- 🐚 Shell configuration details
- 🐱 Kitty keyboard shortcuts
- 📦 tmux shortcuts and plugins
- 🛠️ Modern CLI tool usage
- ⌨️ Complete keyboard shortcut reference
- 📝 Custom function documentation
- 🔧 Troubleshooting guide

### 📜 License

MIT License
