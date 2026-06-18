# dotfiles — AGENTS.md

macOS personal dotfiles managed by [GNU Stow](https://www.gnu.org/software/stow/). Each subdirectory is a stow package mapping into `$HOME`.

## Essential commands

```bash
./configure link|unlink|reinstall|doctor|list   # stow 15 packages (see `configure` line 13-17)
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
| `nvim/` | `.config/nvim/` | lazy.nvim, 18 plugin specs in `lua/plugins/` |
| `ghostty/` | `.config/ghostty/config` | `Maple Mono NF CN` for unified Latin+CJK; `macos-option-as-alt = true` required for `<A-...>` keybindings |
| `docker/` | `docker-compose-ai.yml` | Ollama + ChromaDB + Qdrant + pgvector (no Open WebUI) |
| `conda/` | `.condarc` | USTC mirror, lazy-loaded in .zshrc |
| `npm/` | `.npmrc` | npmmirror registry |
| `pip/` | `pip.conf` | Tsinghua mirror |
| `brew/` | `.Brewfile` | All Homebrew formulae + casks |
| `yazi/` | `yazi.toml` `keymap.toml` | Terminal file manager |
| `zellij/` | `config.kdl` | Terminal multiplexer |
| `btop/` | `btop.conf` | System monitor, Tokyo Night colors |
| `fastfetch/` | `config.jsonc` | System info, only on interactive non-TMUX non-Ghostty sessions |
| `lazygit/` | `config.yml` | Git TUI |

## Conventions

- **Tokyo Night Storm** theme across all tools
- **XDG** dirs (`XDG_CONFIG_HOME`/`CACHE_HOME`/`DATA_HOME`)
- Aliases: `vim`/`vi`/`v` → nvim, `cat` → bat, `ls` → eza, `grep` → rg, `diff` → delta, `top` → btop
- **mise** manages runtimes (not pyenv/nvm/rbenv), installed by Homebrew
- **carapace** provides shell completions (not fzf's `--zsh`, avoids compinit conflicts)
- `mapleader` is `<Space>`, `maplocalleader` is also `<Space>`
- `justfile` tasks: `activate`, `jupyter`, `ollama`, `update`, `freeze`, `gpu`, `ane`

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
- `<C-l>` = window right (normal mode); `<C-y>` = Avante accept (insert mode); `<C-L>` removed (can't distinguish from `<C-l>` in terminals)
- Avante provider config uses same model (`openrouter/owl-alpha`) for both `fast` and `strong` — switching provider is cosmetic only
- `configure` packages array at line 13-17 is the source of truth for stow operations
- `docker-compose-ai.yml` requires `colima start` before `docker compose up`
