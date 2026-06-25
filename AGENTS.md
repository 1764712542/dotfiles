# dotfiles — AGENTS.md

macOS personal dotfiles managed by [GNU Stow](https://www.gnu.org/software/stow/). Each subdirectory is a stow package mapping into `$HOME`.

## Essential commands

```bash
./configure link|unlink|reinstall|doctor|list   # stow 17 packages (see `configure` line 13-17)
brew bundle --file brew/.Brewfile               # install all Homebrew packages
zimfw install                                    # install Zim modules
mise install                                     # install runtimes (Python/Node/Go/Rust)
just <task>                                      # task runner (AI dev, see justfile)
```

First Neovim launch auto-runs `:Lazy! sync`. Stow must run from repo root — `configure` handles this.

## Structure

| Package | Target | Notes |
|---------|--------|-------|
| `zsh/` | `.zshenv` `.zprofile` `.zshrc` | `.zshenv` sources `~/.cargo/env`, loads `OPENROUTER_API_KEY` via `security find-generic-password`; `.zprofile` uses USTC Homebrew mirrors |
| `zim/` | `.zimrc` | Zimfw modules + zsh-abbr + p10k |
| `p10k/` | `.p10k.zsh` | Pure-style prompt, Tokyo Night colors |
| `git/` | `.gitconfig` | SSH insteadOf for GitHub; no proxy in config |
| `nvim/` | `.config/nvim/` | lazy.nvim, 20 plugin specs in `lua/plugins/` |
| `ghostty/` | `.config/ghostty/config` | `Maple Mono NF CN` for unified Latin+CJK; `macos-option-as-alt = true` required for `<A-...>` keybindings |
| `docker/` | `docker-compose-ai.yml` | Ollama + ChromaDB + Qdrant + pgvector (no Open WebUI) |
| `npm/` | `.npmrc` | npmmirror registry |
| `pip/` | `.config/pip/pip.conf` | Tsinghua mirror |
| `brew/` | `.Brewfile` | All Homebrew formulae + casks |
| `yazi/` | `yazi.toml` `keymap.toml` | Terminal file manager |
| `zellij/` | `config.kdl` | Terminal multiplexer |
| `btop/` | `btop.conf` | System monitor, Tokyo Night colors |
| `fastfetch/` | `config.jsonc` | System info, on interactive shell and not inside Zellij |
| `lazygit/` | `config.yml` | Git TUI |
| `mise/` | `.config/mise/config.toml` | Runtime versions (Node 22, Python 3.12) |
| `cheatsheet/` | `ai-dev-cheatsheet.md` | AI dev quick reference |

## Conventions

- **Tokyo Night Storm** theme across all tools
- **XDG** dirs (`XDG_CONFIG_HOME`/`CACHE_HOME`/`DATA_HOME`)
- Aliases: `vim`/`vi`/`v` → nvim, `cat` → bat, `ls` → eza, `grep` → rg, `diff` → delta, `top` → btop
- **uv** manages Python packages (primary, not pip); `ai` alias sources `~/.venvs/ai/bin/activate`
- **mise** manages runtimes (not pyenv/nvm/rbenv), installed by Homebrew
- **carapace** provides shell completions (not fzf's `--zsh`, avoids compinit conflicts)
- `mapleader` is `<Space>`, `maplocalleader` is also `<Space>`
- `justfile` tasks: `activate`, `jupyter`, `ollama`, `chroma`, `lmstudio`, `fix`, `lint`, `update`, `freeze`, `update-all`, `clean`, `doctor`, `gpu`, `ane`

## Keymap conflict status — Neovim

Fixed in previous sessions: Avante `auto_set_keymaps=false` (now in `core/keymaps.lua`), flash.nvim moved to `<leader>j`/`<leader>k`, neotest output moved to `<leader>tO` to avoid `<leader>to` race with tabonly, dead which-key groups `<leader>q/r/u/n` removed.

Note: `<C-l>` and `<C-L>` send the same byte (0x0C) in terminals — Neovim can't distinguish them. `<C-L>` mapping removed; `<C-l>` now works for smart-splits window right. Use `<leader>h` for nohlsearch, `<leader>rr` for redraw.

### Intentional overrides

`gt` → Trouble diagnostics (overrides `:tabnext`); `<C-\>` in terminal → ToggleTerm (uses `<Esc><Esc>` as escape); `<C-p>` → snacks command palette.

## Gotchas

- `.zshenv` sources `~/.cargo/env`, sets `HTTPS_PROXY` (OpenRouter needs a proxy in China), loads API keys via `security find-generic-password` — all must exist
- Neovim `lazy-lock.json` is a lockfile — do not edit manually
- LSP config uses `vim.lsp.config`/`vim.lsp.enable` — requires Neovim >= 0.11
- `./configure doctor` checks symlinks at depth-1/2/3 — covers `~` and `~/.config`, but not orphan files
- Ghostty `macos-option-as-alt = true` enables `<A-...>` keybindings; `cursor-color = #7dcfff`
- `<C-l>` = window right (normal mode); `<C-y>` = Supermaven accept (insert mode); `<C-L>` removed (can't distinguish from `<C-l>` in terminals)
- `im-select.nvim` auto-switches to ABC input method on `InsertLeave` — prevents Chinese IME from breaking `jk` escape or inserting Chinese chars into normal mode commands
- Avante uses `openrouter/owl-alpha` via OpenRouter
- `configure` PACKAGES array (line 13-17) is the source of truth for stow operations
- `docker-compose-ai.yml` requires `colima start` before `docker compose up`
- Detailed environment reference in `.opencode/rules/system.mdc` (agent pref, proxy, toolchain, code style), `dev-environment.md` (shell aliases/keymaps), and `ml-dl-reference.md` (ML/DL setup)
