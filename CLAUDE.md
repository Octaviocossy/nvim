# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration in Lua — not an application. There is no build step and no test suite; "verifying a change" means loading it in Neovim and checking for errors. Targets **Neovim ≥ 0.11** (developed on 0.12) and leans on native APIs (`vim.lsp.config`/`vim.lsp.enable`, `vim.diagnostic.jump`, treesitter `foldexpr`, native `gc` commenting), so it will break on older Neovim.

External tools: ripgrep (picker grep), the `tree-sitter` CLI + a C compiler (treesitter parsers), Node/npm (`eslint_d`, `prettier`, `tree-sitter-cli`). LSP servers and formatters auto-install via mason on first launch. See `README.md` for the full dependency list.

## How it loads (read these to understand control flow)

- `init.lua` → `require("core")` → `lua/core/init.lua`, which requires `core.options`, `core.keymaps`, then `core.lazy` (order matters).
- `lua/core/lazy.lua` bootstraps lazy.nvim and calls `lazy.setup({ { import = "plugins" } })`. **Every file in `lua/plugins/` is auto-imported** and must return a lazy spec (or a list of specs). To add a plugin, drop in a new file — there is no central plugin list to edit.
- `lua/core/utils.lua` exposes the `keymap_*` helpers (`nnoremap`, etc.) used throughout. Leader key is **space**.

## Cross-file coupling to know about

- **LSP keymaps live in `lua/core/keymaps.lua`**, not in `lsp.lua`. `keymaps.lua` defines `M.map_lsp_keybinds(bufnr)`, which the `LspAttach` autocmd in `lua/plugins/lsp.lua` invokes per buffer. Change LSP keybinds in keymaps.lua.
- Global keymaps (also keymaps.lua) call plugins directly — notably the **`Snacks` global** (`Snacks.picker.*`, `Snacks.explorer`, `Snacks.picker.git_status`), plus `require("trouble")`, `require("spectre")`, etc.

## Feature → plugin ownership (non-obvious; avoids adding redundant plugins)

- **snacks.nvim** (`snacks.lua`) is one plugin supplying many features: the fuzzy **picker** (replaces Telescope), **indent** guides, **input** UI, **notifier**/LSP progress, and **words** (cursor-word highlight). Its `Snacks` global is used directly in keymaps.
- **blink.cmp** (`blink.lua`) is completion (+ snippets via friendly-snippets); that file also declares the standalone `nvim-autopairs` and `nvim-ts-autotag` specs.
- **`lsp.lua` bundles three specs**: `nvim-lspconfig`, `conform.nvim` (formatting), and `trouble.nvim`.
- Commenting (`gc`/`gcc`) and folding (treesitter `foldexpr`, set in `options.lua`) are **Neovim built-ins**, not plugins.

## LSP (lua/plugins/lsp.lua)

Native 0.11 flow: per-server tables in the `servers` table are registered via `vim.lsp.config(name, …)` and turned on with `vim.lsp.enable(…)` (not the old `lspconfig[name].setup()` loop). Completion capabilities come from blink via `vim.lsp.config("*", …)`. mason + mason-lspconfig install the servers (`ensure_installed = keys(servers)`, `automatic_enable = false`); mason-tool-installer installs the formatters. An `LspAttach` autocmd attaches navic, applies the keymaps, and disables the eslint/biome LSP formatting (conform owns formatting).

The `eslint` and `biome` LSPs each **auto-attach only when their project config exists** (an eslint config / a `biome.json`), so they're mutually exclusive per project and safe to leave enabled globally. Formatting runs via conform on save (`BufWritePre`) and `<leader>f`, with project-aware formatter selection (see the helpers in the conform spec): JS/TS → `biome-check` if a `biome.json` exists, else `eslint_d` if an eslint config exists, else `prettier`; JSON/CSS prefer biome too; Lua → stylua.

## Treesitter — important constraints

- Pinned to the **`main` branch** (the rewrite). It compiles parsers with the **`tree-sitter` CLI** (`npm install -g tree-sitter-cli`) plus a C compiler — neither is bundled.
- The old `master` branch is archived and **crashes on Neovim 0.12** during injection highlighting; do not switch back.
- Highlighting and indent start via a `FileType` autocmd (`vim.treesitter.start()`); textobjects use the new `select`/`move` API in `treesitter.lua`. Incremental selection does not exist on `main`.

## lazy-lock.json is committed on purpose

It pins plugin versions to prevent drift (an unpinned `:Lazy sync` once pulled an incompatible nvim-treesitter and broke the config). Keep it committed; `:Lazy sync` regenerates it after plugin changes.

## Common commands

- Install/update/clean plugins: `nvim --headless "+Lazy! sync" +qa`
- Syntax-check a Lua file without executing it: `luajit -e "assert(loadfile('lua/plugins/foo.lua'))"`
- Update/install treesitter parsers: `:TSUpdate`, or `require('nvim-treesitter').install({ ... })` (needs the tree-sitter CLI)
- Health checks: `:checkhealth <plugin>` (e.g. `blink.cmp`, `snacks`)

### Verifying changes headlessly (gotchas)

- Surface load errors by opening a file and dumping messages: `nvim --headless "+e <file>" "+sleep 2" "+messages" +qa`. lazy swallows config errors into notifications, so also check `:messages` / `:checkhealth`.
- Some snacks integrations (`vim.ui.select`/`vim.ui.input`) only activate on **`UIEnter`**, which does not fire under `--headless`; trigger it with `+"doautocmd UIEnter"` when verifying them.
