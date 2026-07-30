load-keychain() {
    (( ${_DOTFILES_KEYCHAIN_LOADED:-0} )) && return 0
    (( $+commands[security] )) || return 1

    local key value
    local -a keys=(
        OPENROUTER_API_KEY CLOUDFLARE_AI_TOKEN ZEN_API_KEY_1 ZEN_API_KEY_2
        DEEPSEEK_API_KEY AGNES_API_KEY FOX_API_KEY ANTHROPIC_AUTH_TOKEN
        SHAREDCHAT_API_KEY CLOUD_AI_API_KEY OPENCODE_GO_API_KEY ASL_API_KEY
    )
    for key in $keys; do
        [[ -n "${(P)key}" ]] && continue
        value=$(security find-generic-password -s "$key" -w 2>/dev/null) || continue
        typeset -gx "$key=$value"
    done
    [[ -n "$ASL_API_KEY" ]] && export ANTHROPIC_AUTH_TOKEN="$ASL_API_KEY"
    typeset -gx _DOTFILES_KEYCHAIN_LOADED=1
}

claude() { load-keychain; command claude "$@" }
opencode() { load-keychain; command opencode "$@" }

mkcd() { mkdir -pv "$1" && cd "$1"; }
take() { mkdir -p "$1" && cd "$1"; }

t() {
    if [[ -n "$ZELLIJ" ]]; then
        echo "Already in Zellij session"
        zellij list-sessions 2>/dev/null
    else
        command zellij attach --create "${1:-default}"
    fi
}

extract() {
    [[ -f "$1" ]] || { echo "'$1' is not a valid file"; return 1; }
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz) tar xzf "$1" ;;
        *.tar.xz) tar xJf "$1" ;;
        *.tar) tar xf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unar "$1" ;;
        *.gz) gunzip "$1" ;;
        *.xz) xz -d "$1" ;;
        *.lz4) lz4 -d "$1" "$1.out" && mv "$1.out" "${1%.lz4}" ;;
        *.zst) zstd -d "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.deb) ar x "$1" ;;
        *) echo "'$1' cannot be extracted via extract()"; return 1 ;;
    esac
}

ff() { find . -type f -iname "*$1*"; }
weather() { curl -s "wttr.in/$1?lang=zh"; }

note() {
    local note_dir="$HOME/Documents/notes"
    mkdir -p "$note_dir"
    nvim "$note_dir/${1:-$(date +%Y-%m-%d)}.md"
}

dstop() {
    local -a containers=(${(f)"$(docker ps -q 2>/dev/null)"})
    (( $#containers )) || { echo "没有运行中的容器"; return 0; }
    echo "停止 $#containers 个容器..."
    docker stop $containers
}

gacf() {
    [[ -n "$1" ]] || { echo "用法: gacf <commit message>" >&2; return 2; }
    local entry old index
    local -a files choices selected
    while IFS= read -r -d $'\0' entry; do
        files+=("${entry[4,-1]}")
        choices+=("$#files\t${entry[1,2]} ${entry[4,-1]}")
        [[ "${entry[1,2]}" == *[RC]* ]] && IFS= read -r -d $'\0' old
    done < <(git status --porcelain=v1 -z)
    (( $#choices )) || { echo "没有可提交的文件"; return 0; }
    while IFS=$'\t' read -r -d $'\0' index _; do
        selected+=("${files[index]}")
    done < <(printf '%s\0' $choices | fzf --read0 --print0 --multi --delimiter=$'\t' --with-nth=2..)
    (( $#selected )) && git add -- $selected && git commit -m "$1"
}

fo() {
    local file
    file=$(fzf --preview 'bat --color=always -- "{}"') || return
    [[ -n "$file" ]] && nvim -- "$file"
}

fzd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null |
        fzf --preview 'eza --tree --icons --color=always --level=2 -- "{}"') || return
    [[ -n "$dir" ]] && cd "$dir"
}

gr() {
    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null) && cd "$root"
}

port() { lsof -iTCP -sTCP:LISTEN -n -P | rg -i -- "$1"; }
ipinfo() { curl -s "ipinfo.io/$1" | jq .; }

# prox Go CLI 包装——eval 让环境变量在当前 shell 生效
proxy() {
    case "${1:-status}" in
        on|start)
            shift
            eval "$(prox on "$@")"
            ;;
        off|stop)
            eval "$(prox off)"
            ;;
        switch|select)
            eval "$(prox switch)"
            ;;
        status) prox status ;;
        list)   prox list ;;
        *)
            echo "用法:"
            echo "  proxy on              开启代理 (默认 7892)"
            echo "  proxy on -p 7897      指定端口开启"
            echo "  proxy on -s           开启 SOCKS5 代理"
            echo "  proxy off             关闭代理"
            echo "  proxy switch          交互式选择端口"
            echo "  proxy list            列出预设端口"
            echo "  proxy status          查看代理状态"
            ;;
    esac
}

export ZEN_PROXY_PORT=${ZEN_PROXY_PORT:-8123}
ZEN_PROXY_PID_FILE="${XDG_RUNTIME_DIR:-$XDG_CACHE_HOME}/zen-proxy.pid"
ZEN_PROXY_LOG_FILE="${XDG_CACHE_HOME}/zen-proxy.log"

_zen-proxy-pid() {
    [[ -r "$ZEN_PROXY_PID_FILE" ]] || return 1
    local pid=$(<"$ZEN_PROXY_PID_FILE") command_line
    [[ "$pid" == <-> ]] && kill -0 "$pid" 2>/dev/null || return 1
    command_line=$(ps -o command= -p "$pid" 2>/dev/null) || return 1
    [[ "$command_line" == *"$HOME/.local/bin/zen-proxy $ZEN_PROXY_PORT"* ]] && print -r -- "$pid"
}

_zen-proxy-start() {
    local pid
    pid=$(_zen-proxy-pid) && { echo "→ Zen proxy 已运行 (PID: $pid)"; return 0; }
    [[ -x "$HOME/.local/bin/zen-proxy" ]] || { echo "✗ 找不到 ~/.local/bin/zen-proxy"; return 1; }
    load-keychain
    mkdir -p "${ZEN_PROXY_PID_FILE:h}" "${ZEN_PROXY_LOG_FILE:h}"
    nohup "$HOME/.local/bin/zen-proxy" "$ZEN_PROXY_PORT" >| "$ZEN_PROXY_LOG_FILE" 2>&1 &
    pid=$!
    print -r -- "$pid" >| "$ZEN_PROXY_PID_FILE"
    sleep 0.5
    kill -0 "$pid" 2>/dev/null && { echo "✓ Zen proxy 已启动 (PID: $pid) port=$ZEN_PROXY_PORT"; return 0; }
    rm -f "$ZEN_PROXY_PID_FILE"
    echo "✗ 启动失败, 查看日志: $ZEN_PROXY_LOG_FILE"
    return 1
}

zen-proxy() {
    local cmd="${1:-start}" pid uptime
    case "$cmd" in
        start) _zen-proxy-start ;;
        stop)
            pid=$(_zen-proxy-pid) || { rm -f "$ZEN_PROXY_PID_FILE"; echo "→ Zen proxy 未运行"; return 0; }
            kill "$pid" && rm -f "$ZEN_PROXY_PID_FILE"
            echo "✓ Zen proxy 已停止 (PID: $pid)"
            ;;
        restart) zen-proxy stop && zen-proxy start ;;
        status)
            pid=$(_zen-proxy-pid) || { echo "✗ Zen proxy 未运行"; return 1; }
            uptime=$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ')
            echo "✓ Zen proxy 运行中 (PID: $pid, 已运行: ${uptime:-?})"
            curl -fsS "http://127.0.0.1:$ZEN_PROXY_PORT/status" | python3 -m json.tool 2>/dev/null || echo "  (无法连接 status 端点)"
            ;;
        log) command cat "$ZEN_PROXY_LOG_FILE" ;;
        *) echo "用法: zen-proxy start|stop|status|restart|log"; return 2 ;;
    esac
}

zen-switch() {
    local resp key
    resp=$(curl -fsS "http://127.0.0.1:$ZEN_PROXY_PORT/switch") || { echo "✗ Zen proxy 未运行 (zen-proxy start)"; return 1; }
    key=$(print -r -- "$resp" | python3 -c "import sys,json; print(json.load(sys.stdin)['active_key'])")
    echo "✓ 已切换到 Key $key"
}

zen-status() {
    curl -fsS "http://127.0.0.1:$ZEN_PROXY_PORT/status" | python3 -m json.tool || {
        echo "✗ Zen proxy 未运行 (zen-proxy start)"
        return 1
    }
}

export MANPATH_ZH="$HOME/.local/share/man-pages-zh/src"
cman() { man -M "$MANPATH_ZH" "$@"; }
cht() {
    if [[ "$2" == en ]]; then
        curl -s "cheat.sh/$1"
    else
        curl -s "cheat.sh/$1?q=zh"
    fi
}
