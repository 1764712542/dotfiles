if [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif (( $+commands[fzf] )); then
    fzf_share="${commands[fzf]:h:h}/share/fzf"
    [[ -r "$fzf_share/shell/key-bindings.zsh" ]] && source "$fzf_share/shell/key-bindings.zsh"
    unset fzf_share
fi

export FZF_DEFAULT_OPTS="
  --height 50% --layout=reverse --border=rounded --info=inline-right
  --prompt='  ' --pointer=' ' --marker='>' --separator='─' --scrollbar='│'
  --bind='ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
  --bind='ctrl-/:toggle-preview' --bind='ctrl-a:select-all' --bind='double-click:accept'
  --color=bg+:#292e42,bg:#24283b,spinner:#7aa2f7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#bb9af7,info:#565f89,pointer:#7dcfff
  --color=marker:#bb9af7,fg+:#c0caf5,prompt:#7dcfff,hl+:#7dcfff
  --color=border:#3b4261,query:#c0caf5 --preview-window=border-rounded --margin=1,2"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .opencode --exclude .cache --exclude .local/share/mise'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always --level=2 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Ctrl-Y: 复制到剪贴板' --color=header:#565f89"

(( $+commands[atuin] )) && eval "$(atuin init zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
alias zi='z -i' za='z -b .'
(( $+commands[mise] )) && eval "$(mise activate zsh)"
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
