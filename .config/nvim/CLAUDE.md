# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Lua configuration for Neovim 0.12 with LuaJIT. Plugins are managed by lazy.nvim, and the leader key is `<Space>`.

## Architecture

- `init.lua` — Entry point. Loads options, remaps, external-change synchronization, packages, and LSP setup.
- `lua/packages.lua` — Bootstraps lazy.nvim and imports specs from `bearguns.plugins`
- `lua/bearguns/options.lua` — Core Neovim options (4-space tabs, relative line numbers, dark theme, etc.)
- `lua/bearguns/remap.lua` — Global keymaps (window management via `<leader>w*`, line moving with `J`/`K` in visual)
- `lua/bearguns/sync.lua` — Checks open files for external edits when focus or buffers change
- `lua/bearguns/mise.lua` — Builds Mise-backed LSP commands and resolves Mise installation roots
- `lua/bearguns/lsp-setup.lua` — Enables native `vim.lsp` configurations and defines shared `LspAttach` behavior
- `lua/bearguns/plugins/` — One lazy.nvim spec file per plugin (or small plugin family, e.g. `mini.lua`)
- `lsp/` — Native Neovim LSP configurations, one file per server

## LSP Setup

Uses native `vim.lsp` configurations from `lsp/`; Mason is not a runtime dependency. Mise provides `vtsls`, Vue LS, and Tailwind LS. Lua LS continues to resolve from Homebrew. Svelte LSP is disabled until `svelteserver` is installed.

`vtsls` handles JavaScript, JSX, TypeScript, TSX, and the TypeScript portions of Vue files. Its `@vue/typescript-plugin` path is derived from Mise's `npm:@vue/language-server` installation. `vue_ls` handles the remaining Vue features and forwards its `tsserver/request` messages to `vtsls`. Tailwind LS attaches to JSX/TSX as well as the other web filetypes and discovers each project's configuration automatically.

## External File Synchronization

`autoread` is enabled. `FocusGained`, `TermLeave`, and `BufEnter` run `:checktime`, so clean buffers reload after Codex or another process edits them. Modified Neovim buffers are never overwritten; Neovim reports the conflict instead. `:SyncExternalChanges` performs the same check manually.

tmux has focus events enabled so selecting the Neovim pane produces `FocusGained`. Navigation remains prefix-based: use `<Space>w` followed by `h`/`j`/`k`/`l` for Neovim splits, and tmux's `Ctrl-Space` prefix followed by `h`/`j`/`k`/`l` for panes.

## Key Plugins

- **conform.nvim** — Formatting and safe fixes (`oxfmt`, `oxlint`, `stylua`). Format-on-save enabled. Manual format: `<leader>T`
- **nvim-lint** — Linting (project-local ESLint for JS/JSX/TS/TSX/Vue/Svelte). Lints on save. Manual lint: `<leader>l`
- **fzf-lua** — Fuzzy finder (`<leader>ff` files, `<leader>pf` git files, `<leader>pg` live grep, `<leader>bb` buffers)
- **Native LSP completion** — Enabled on `LspAttach` with automatic triggering
- **nvim-ts-autotag** — Auto-closes and renames JSX/TSX/HTML tags
- **mini.pairs / mini.icons** — Auto-pairs and icon support
- **catppuccin** — Active colorscheme (`catppuccin-frappe`)

## Conventions

- Plugins are registered and configured in `lua/bearguns/plugins/<plugin>.lua`, each returning a lazy.nvim spec
- Lua modules live under the `bearguns` namespace (`require("bearguns.<name>")`)
- LSP server configs return native `vim.lsp.Config` tables from `lsp/<server>.lua`
- Node-based language servers run through `mise exec --`; do not add them to Mason
- Formatting uses conform.nvim, not LSP formatting
- Tabs are 4 spaces, indentation uses `smartindent`
