alias vim=nvim vi=nvim v=nvim
alias cat='bat --paging=never' catp=bat
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --level=3 --git'
alias lla='eza -la --icons --group-directories-first --git'
alias ld='eza -la --icons --group-directories-first --git --sort=modified'
alias grep=rg diff=delta

alias ..='cd ..' ...='cd ../..' ....='cd ../../..'
alias -- -='cd -'
alias mkdir='mkdir -pv'

alias gs='git status' ga='git add' gaa='git add --all'
alias gc='git commit' gcm='git commit -m'
alias gp='git push' gpl='git pull' gpr='git pull --rebase'
alias gd='git diff' gds='git diff --staged'
alias gco='git checkout' gcb='git checkout -b' gb='git branch'
alias glog='git log --oneline --graph --decorate --all'
alias glogp='git log --oneline --graph --decorate -20'
alias gst='git stash' gstp='git stash pop' gstl='git stash list'
alias gclean='git clean -nd'
alias gsync='git fetch && git rebase'

alias cp='cp -iv' mv='mv -iv' rm='rm -iv' ln='ln -iv'
alias c=clear
alias h='history 1' hg='history 1 | rg'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
alias path='print -l ${(s.:.)PATH}'
alias reload='exec zsh'
alias zshconfig='nvim ~/.zshrc ~/.zsh/*.zsh'
alias p10kconfig='nvim ~/.p10k.zsh'
alias zellijconfig='nvim ~/.config/zellij/config.kdl'

alias ql='qlmanage -p &>/dev/null'
alias myip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'
alias ping='ping -c 5'

alias d=docker dc='docker compose' dps='docker ps' dpsa='docker ps -a'
alias di='docker images' drm='docker rm' drmi='docker rmi'
alias dprune='docker system prune'
alias top=btop bt=btop lg=lazygit
alias jqless='jq -C | less -R' yqless='yq -C | less -R'
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewcask='brew install --cask'
alias pytest='pytest -v --tb=short --no-header'
alias codexchat='codex --profile chatgpt'
