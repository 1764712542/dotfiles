. "$HOME/.cargo/env"

# Load API keys from macOS Keychain
export CODE_COMPANION_KEY="$(security find-generic-password -s CODE_COMPANION_KEY -w 2>/dev/null)"
export OPENROUTER_API_KEY="$(security find-generic-password -s OPENROUTER_API_KEY -w 2>/dev/null)"
