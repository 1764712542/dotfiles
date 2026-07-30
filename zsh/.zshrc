if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export COLIMA_HOME="$XDG_CONFIG_HOME/colima"
export GOPATH="$HOME/go"
export BAT_THEME="TokyoNight Storm"
export BAT_PAGER="less -RF"
export LESS="-R -F -X -K"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/go/bin"
    ${commands[brew]:h}/opt/node@22/bin(N)
    "$HOME/.cache/.bun/bin"(N)
    $path
    /opt/metasploit-framework/bin(N)
    /opt/wpscan/bin(N)
)

HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS
setopt HIST_VERIFY SHARE_HISTORY EXTENDED_HISTORY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT CDABLE_VARS
setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD LIST_ROWS_FIRST

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{7}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{1}-- no matches found --%f'
zstyle ':completion:*:corrections' format '%F{3}-- %d (errors: %e) --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME/zsh"

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
    default none
    unknown-token 'fg=#f7768e,bold'
    reserved-word 'fg=#7dcfff,bold'
    alias 'fg=#9ece6a'
    builtin 'fg=#7dcfff'
    function 'fg=#9ece6a,bold'
    command 'fg=#9ece6a'
    precommand 'fg=#9ece6a,underline'
    hashed-command 'fg=#9ece6a'
    path 'fg=#7aa2f7,underline'
    path_prefix 'fg=#7aa2f7,underline'
    path_approx 'fg=#e0af68,underline'
    globbing 'fg=#7aa2f7,bold'
    history-expansion 'fg=#7aa2f7,bold'
    single-hyphen-option 'fg=#7dcfff'
    double-hyphen-option 'fg=#7dcfff'
    single-quoted-argument 'fg=#e0af68'
    double-quoted-argument 'fg=#e0af68'
    dollar-double-quoted-argument 'fg=#7dcfff'
    back-double-quoted-argument 'fg=#7dcfff'
    comment 'fg=#565f89,italic'
)

bindkey -e
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[^?' backward-kill-word
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^_' undo
bindkey '^x^r' redo

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_HISTORY_IGNORE='(l[sl]|cd|pwd|exit|clear|history|reload)[\t ]*'

ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"
if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR:-$HOME}/.zimrc}" ]]; then
    if [[ -r /opt/homebrew/opt/zimfw/share/zimfw.zsh ]]; then
        source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
    elif [[ -r /usr/local/opt/zimfw/share/zimfw.zsh ]]; then
        source /usr/local/opt/zimfw/share/zimfw.zsh init
    fi
fi
[[ -r "$ZIM_HOME/init.zsh" ]] && source "$ZIM_HOME/init.zsh"

source "${ZDOTDIR:-$HOME}/.zsh/aliases.zsh"
source "${ZDOTDIR:-$HOME}/.zsh/functions.zsh"
source "${ZDOTDIR:-$HOME}/.zsh/integrations.zsh"

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

if [[ -z "$ZELLIJ" && -z "$SSH_CONNECTION" ]] && (( $+commands[fastfetch] )); then
    (fastfetch --pipe false &) >/dev/null 2>&1
fi

# pentest-ai findings database
export PATH="$HOME/.pentest-ai/bin:$PATH"

# kimi-code
export PATH="/Users/zhuyao/.kimi-code/bin:$PATH"
