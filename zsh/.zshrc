# ==============================================================================
#  ~/.zshrc — Zimfw + Modern Terminal Stack
#  Theme: Tokyo Night Storm | Font: Maple Mono NF
#  Updated: 2026-04-28
# ==============================================================================

# Powerlevel10k instant prompt (must be at the very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
#  Zimfw Initialization
# ==============================================================================

ZIM_HOME=~/.zim
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh

# ==============================================================================
#  Environment Variables
# ==============================================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'

# XDG 规范
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# 现代工具配置
export BAT_THEME="TokyoNight Storm"
export BAT_PAGER="less -RF"
export LESS="-R -F -X -K"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # man 页面用 bat 渲染

# ==============================================================================
#  Path
# ==============================================================================
# brew shellenv 已在 .zprofile 中加载，此处无需重复
export PATH="$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
. "$HOME/.cargo/env"
export PATH="$PATH:/opt/metasploit-framework/bin"
export PATH="$PATH:/opt/wpscan/bin"
export PATH="$PATH:/Users/zhuyao/.lmstudio/bin"
export PATH="$PATH:/Applications/LM Studio.app/Contents/MacOS"

# ==============================================================================
#  History
# ==============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ==============================================================================
#  Key Bindings
# ==============================================================================

bindkey -e
# 删除
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
# 单词跳转
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[^?' backward-kill-word
# Alt+方向键 (macOS)
bindkey '^[f' forward-word
bindkey '^[b' backward-word
# 行首行尾
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
# 上下搜索历史 (匹配当前输入)
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Undo/Redo
bindkey '^_' undo
bindkey '^x^r' redo

# ==============================================================================
#  Directory Navigation
# ==============================================================================

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CDABLE_VARS

# ==============================================================================
#  Completion
# ==============================================================================

setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt LIST_ROWS_FIRST

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{7}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{1}-- no matches found --%f'
zstyle ':completion:*:corrections' format '%F{3}-- %d (errors: %e) --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
mkdir -p ~/.zsh/cache 2>/dev/null

# ==============================================================================
#  Syntax Highlighting Styles (Tokyo Night)
# ==============================================================================

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#7dcfff,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[function]='fg=#9ece6a,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#9ece6a,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[path]='fg=#7aa2f7,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#7aa2f7,underline'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=#e0af68,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#7aa2f7,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#7aa2f7,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89,italic'

# ==============================================================================
#  Autosuggestions
# ==============================================================================

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_HISTORY_IGNORE='(l[sl]|cd|pwd|exit|clear|history|reload)[\t ]*'

# ==============================================================================
#  fzf — Fuzzy Finder
# ==============================================================================

# 使用 key-bindings.zsh 而非 fzf --zsh, 避免 compinit 冲突
if [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
elif command -v fzf &>/dev/null; then
  # 备用: 直接从 fzf 获取路径
  _fzf_share="$(dirname "$(dirname "$(command -v fzf)")")/share/fzf"
  [[ -f "$_fzf_share/shell/key-bindings.zsh" ]] && source "$_fzf_share/shell/key-bindings.zsh"
  unset _fzf_share
fi

export FZF_DEFAULT_OPTS="
  --height 50%
  --layout=reverse
  --border=rounded
  --info=inline-right
  --prompt='  '
  --pointer=' '
  --marker='>'
  --separator='─'
  --scrollbar='│'
  --bind='ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-a:select-all'
  --bind='double-click:accept'
  --color=bg+:#292e42,bg:#24283b,spinner:#7aa2f7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#bb9af7,info:#565f89,pointer:#7dcfff
  --color=marker:#bb9af7,fg+:#c0caf5,prompt:#7dcfff,hl+:#7dcfff
  --color=border:#3b4261,query:#c0caf5
  --preview-window=border-rounded
  --margin=1,2
"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always --level=2 {}'"

# Ctrl+R 历史搜索增强
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Ctrl-Y: 复制到剪贴板'
  --color=header:#565f89
"

# ==============================================================================
#  zoxide — Smart Directory Jumping
# ==============================================================================

eval "$(zoxide init zsh)"
alias zi='z -i'
alias za='z -b .'

# ==============================================================================
#  atuin — Shell History
# ==============================================================================
eval "$(atuin init zsh)"

# ==============================================================================
#  carapace — Completions
# ==============================================================================
eval "$(carapace _init zsh)"

# ==============================================================================
#  direnv — Directory-specific env vars
# ==============================================================================
eval "$(direnv hook zsh)"

# ==============================================================================
#  Aliases — Modern CLI Tools
# ==============================================================================

# --- 核心替代 ---
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias cat="bat --paging=never"
alias catp="bat"
alias ls="eza --icons --group-directories-first"
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --level=3 --git'
alias lla='eza -la --icons --group-directories-first --git'
alias ld='eza -la --icons --group-directories-first --git --sort=modified'
alias grep="rg"
alias diff="delta"

# --- 目录导航 ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias mkdir='mkdir -pv'
alias fzd='cd "$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview "eza --tree --icons --color=always --level=2 {}")"'

# --- Git 快捷键 ---
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate --all'
alias glogp='git log --oneline --graph --decorate -20'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gclean='git clean -fd'
alias gpr='git pull --rebase'
alias gsync='git fetch && git rebase'

# --- 安全操作 ---
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias ln='ln -iv'

# --- 系统信息 ---
alias c='clear'
alias h='atuin history'
alias hg='atuin search --interactive'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'
alias zshconfig="nvim ~/.zshrc"
alias p10kconfig="nvim ~/.p10k.zsh"
alias tmuxconfig="nvim ~/.config/tmux/tmux.conf"

# --- Quick Look (macOS) ---
alias ql='qlmanage -p &>/dev/null'

# --- 网络 ---
alias myip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'
alias ping='ping -c 5'

# --- Docker ---
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop $(docker ps -q)'
alias dprune='docker system prune -af'

# --- 进程管理 ---
alias ps='ps aux'
alias top='btop'

# --- JSON/YAML 处理 ---
alias jqless='jq -C | less -R'
alias yqless='yq -C | less -R'

# --- 包管理 ---
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewcask='brew install --cask'

# --- 快速工具启动 ---
alias lg='lazygit'
alias bt='btop'
alias tldr='tldr --color always'
alias ai='source ~/venvs/ai/bin/activate'
alias asitop='asitop --color'

# ==============================================================================
#  Custom Functions
# ==============================================================================

# 创建并进入目录
mkcd() { mkdir -pv "$1" && cd "$1" }
take() { mkdir -p "$1" && cd "$1" }

# tmux 快速会话管理
t() {
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$1" 2>/dev/null || { tmux new-session -d -s "$1" && tmux switch-client -t "$1"; }
  else
    tmux new-session -A -s "${1:-main}"
  fi
}

# 智能解压
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.tar.xz)    tar xJf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.xz)        xz -d "$1"       ;;
      *.lz4)       lz4 -d "$1" "$1".out && mv "$1".out "${1%.lz4}" ;;
      *.zst)       zstd -d "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *.deb)       ar x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# 查找文件
ff() { find . -type f -iname "*$1*" }

# 天气
weather() { curl -s "wttr.in/$1?lang=zh" }

# 快速笔记
note() {
  local note_dir="$HOME/Documents/notes"
  mkdir -p "$note_dir"
  if [ -z "$1" ]; then
    nvim "$note_dir/$(date +%Y-%m-%d).md"
  else
    nvim "$note_dir/$1.md"
  fi
}

# Git 交互式提交 (fzf 选择文件)
gacf() {
  local files
  files=$(git status --porcelain | fzf --multi --preview 'git diff --color=always {2}' | awk '{print $2}')
  if [ -n "$files" ]; then
    echo "$files" | xargs git add
    git commit -m "$1"
  fi
}

# 快速查找并打开文件
fo() {
  local file
  file=$(fzf --preview 'bat --color=always {}')
  [ -n "$file" ] && nvim "$file"
}

# 快速 cd 到 git 仓库根目录
gr() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  [ -n "$root" ] && cd "$root"
}

# 端口查看
port() { lsof -iTCP -sTCP:LISTEN -n -P | grep -i "$1" }

# IP 信息
ipinfo() { curl -s "ipinfo.io/$1" | jq . }

# ==============================================================================
#  中文帮助命令
# ==============================================================================

# tlrc (tldr 中文版) — 已通过 ~/Library/Application Support/tlrc/config.toml 配置默认中文

# 中文 man 手册页 (man-pages-zh)
# 安装: git clone --depth=1 https://github.com/man-pages-zh/manpages-zh.git ~/.local/share/man-pages-zh
export MANPATH_ZH="$HOME/.local/share/man-pages-zh/src"
cman() { man -M "$MANPATH_ZH" "$@" }

# cht.sh — 在线命令示例（支持中文）
# 用法: cht <command>          # 默认中文
#       cht <command> en       # 英文
cht() {
  if [ "$2" = "en" ]; then
    curl -s "cheat.sh/$1"
  else
    curl -s "cheat.sh/$1?q=zh"
  fi
}

# ==============================================================================
#  Startup
# ==============================================================================

# 仅在交互式首窗口显示 fastfetch
if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -z "${GHOSTTY_RESOURCES_DIR:-}" ]]; then
  fastfetch --pipe false
fi

# ==============================================================================
#  Powerlevel10k
# ==============================================================================

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
#  rbenv (if installed)
# ==============================================================================

# mise 已管理所有 runtime，rbenv 不再需要
# if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi
