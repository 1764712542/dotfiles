# nvimdots — Agent Guide

Based on [ayamir/nvimdots](https://github.com/ayamir/nvimdots), on `main` branch (nvim 0.11 stable).

## Entry & Load Order

`init.lua` → `require("core")` → leader map → options → events → pack (lazy.nvim) → keymaps → colorscheme.

`lua/core/`: `init.lua`, `global.lua`, `settings.lua`, `options.lua`, `event.lua`, `pack.lua`.

## Plugin Management

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim); auto-clones itself if missing.

- **Plugin specs**: `lua/modules/plugins/{completion,editor,lang,tool,ui}.lua`
- **Plugin configs**: `lua/modules/configs/{completion,editor,lang,tool,ui}/*.lua`
- **Disabled plugins**: listed in `lua/core/settings.lua` `disabled_plugins`
- Concurrency capped at 20 on macOS (`lua/core/pack.lua:155`)

## User Customization

`lua/user/` is gitignored. Template available in `lua/user_template/`.

Override core config via `extend_config()` in `lua/modules/utils/init.lua:321`:
- `user.settings` → merges into `core.settings`
- `user.options` → merges into `core.options`
- `user.event` → merges autocmd definitions
- `user.configs.*` → per-plugin override (merges tables, replaces if function)

## Keymaps

`lua/keymap/`: `init.lua`, `bind.lua`, `editor.lua`, `ui.lua`, `tool.lua`, `lang.lua`, `completion.lua`, `helpers.lua`.
`<leader>` = `<Space>`.

## Chat (AI)

Uses [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim). API key from env `CODE_COMPANION_KEY`.
Default: OpenRouter free models (see `lua/core/settings.lua` `chat_models`).
Disable by setting `settings["use_chat"] = false`.

## Dev Commands

```sh
# Format Lua (stylua)
stylua --config-path=stylua.toml .

# Lint (luacheck)
luacheck . --std luajit --max-line-length 150 --no-config --globals vim _debugging

# CI runs both on push/PR
```

Conventions: tabs, indent=4, column_width=120, double quotes.

## Notable Settings (in `lua/core/settings.lua`)

| Key | Default | Note |
|-----|---------|------|
| `use_ssh` | `true` | Git clone via SSH |
| `use_copilot` | `true` | Copilot enabled (AI dev env) |
| `format_on_save` | `true` | LSP format on save |
| `chat_api_key` | `"CODE_COMPANION_KEY"` | env var name |
| `colorscheme` | `"tokyonight"` | Tokyo Night Storm |
| `lsp_inlayhints` | `true`  | Inlay hints enabled |
| `lsp_deps` | bashls, clangd, gopls, pyright, ruff, ts_ls, ... | Bootstrap LSPs |
| `treesitter_deps` | bash, c, go, python, rust, typescript, ... | Bootstrap parsers |

## macOS Specifics

- Clipboard: pbcopy / pbpaste (`lua/core/init.lua:52-56`)
- Python3 provider: checks `CONDA_PREFIX` first (`lua/core/options.lua:119-124`)
- Bootstrap: `scripts/install.sh`

## NixOS

`flake.nix` → exports `homeManagerModules.default` from `nixos/`. Also `packages.testEnv` and `devshells.default`.

## CI Workflows

- `.github/workflows/lint_code.yml` — luacheck
- `.github/workflows/style_check.yml` — stylua `--check`
- `.github/workflows/update_lockfile.yml` + `update_flake.yml`

## Gitignore

Ignores `lua/user`, `lua/modules/plugins/custom.lua`, `lua/modules/configs/custom`, `result`.
