---
paths: ["**/.vimrc", "**/init.lua", "**/.config/nvim/**", "**/.vim/**"]
---

# ── EDITORS ──

## Nvim
- 配置: `~/.config/nvim/`
- 插件: lazy.nvim (lua)
- LSP: mason + lspconfig
- keymaps: map<leader>
- 风格参考现有 init.lua

## Vim
- 配置: `~/.vimrc`
- 插件: vim-plug
- 基础: /查找 / %替换 / yy 复制 / dd 删除