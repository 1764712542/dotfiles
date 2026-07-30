#!/bin/bash
# arch-setup.sh — 在 Arch Linux (ARM/OrbStack) 上部署 dotfiles
# 用法: bash arch-setup.sh

set -euo pipefail

echo "==> 安装依赖"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
    base-devel git stow zsh neovim \
    zoxide fzf ripgrep fd eza bat lazygit \
    just luarocks go npm python nodejs \
    xclip curl wget unzip

# yay (AUR helper)
if ! command -v yay &>/dev/null; then
    echo "==> 安装 yay"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    rm -rf /tmp/yay
fi

# 安装 AUR 包
yay -S --noconfirm --needed \
    zsh-zim-git nvim-packer-git \
    stylua shfmt

echo "==> 克隆 dotfiles"
cd ~
git clone https://github.com/1764712542/dotfiles.git ~/dotfiles
cd ~/dotfiles

echo "==> 适配 Arch Linux"

# 1. 修改 .zprofile——不用 brew shellenv
cat > zsh/.zprofile << 'EOF'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export GOPATH="$HOME/go"
export BAT_THEME="TokyoNight Storm"
EOF

# 2. 修改 .zshenv——去掉 keychain 加载，改用 .env 文件
sed -i '/security find-generic-password/d' zsh/.zshenv 2>/dev/null || true
cat >> zsh/.zshenv << 'EOF'
# API Keys from file (Linux)
if [[ -f "$HOME/.env" ]]; then
    source "$HOME/.env"
fi
EOF

# 3. 修改 aliases——brew 换成 pacman
cat >> zsh/.zsh/aliases.zsh << 'EOF'
# Arch Linux
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrm='sudo pacman -Rs'
alias yayup='yay -Syu'
alias yain='yay -S'
EOF

# 4. 修改 .zshrc——fzf/zim 路径
sed -i 's|/opt/homebrew/opt/fzf|/usr/share/fzf|g' zsh/.zshrc 2>/dev/null || true
sed -i 's|/opt/homebrew/opt/zimfw|/usr/share/zimfw|g' zsh/.zshrc 2>/dev/null || true

# 5. 修改 integrations——fzf 路径
sed -i 's|/opt/homebrew/opt/fzf|/usr/share/fzf|g' zsh/.zsh/integrations.zsh 2>/dev/null || true

# 6. pbcopy → xclip
cat >> zsh/.zsh/aliases.zsh << 'EOF'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
EOF

echo "==> 部署配置"
./configure reinstall

echo "==> 设置默认 shell"
chsh -s $(which zsh)

echo "==> 安装 Zim 模块"
zimfw install

echo "==> 安装 Neovim 插件"
nvim --headless "+Lazy! sync" +qa

echo ""
echo "✅ 配置完成！"
echo ""
echo "下一步："
echo "  1. 创建 ~/.env 写入你的 API Key"
echo "     echo 'export DEEPSEEK_API_KEY=xxx' >> ~/.env"
echo "  2. 重开终端：exec zsh"
echo "  3. 打开 nvim 等插件自动安装完毕"
