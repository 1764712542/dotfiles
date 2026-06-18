. "$HOME/.cargo/env"

# Proxy for OpenRouter / AI tools (猫猫云 mixed port 7892 supports HTTP + SOCKS5)
export HTTPS_PROXY=http://127.0.0.1:7892
export ALL_PROXY=socks5h://127.0.0.1:7892
# opencode.ai 直连可访问，Bun fetch 不支持 HTTP proxy CONNECT 隧道

# Load API keys from macOS Keychain
export OPENROUTER_API_KEY="$(security find-generic-password -s OPENROUTER_API_KEY -w 2>/dev/null)"
