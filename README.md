# Dependencies

**_Neovim:_** `brew install neovim` — requires **>= 0.11** (uses native LSP & folding; developed on 0.12). <br/>
**_ripgrep:_** `brew install ripgrep` — used by the picker's live grep. <br/>
**_tree-sitter CLI:_** `npm install -g tree-sitter-cli` — required by nvim-treesitter (main branch) to build parsers. <br/>
**_C compiler:_** `xcode-select --install` (macOS) — used by the tree-sitter CLI to compile parsers. <br/>

LSP servers (including **biome**) and formatters (prettier, eslint_d, stylua, black, isort, rustfmt,
goimports) are installed automatically via [mason](https://github.com/mason-org/mason.nvim) on first
launch. JS/TS/JSON/CSS tooling is project-aware: **Biome** is used when a `biome.json` is present
(formatting via conform, linting/code-actions via the Biome LSP), otherwise it falls back to
ESLint/Prettier.

## WSL dependencies:

**_GCC:_** `sudo apt install build-essential`

# Packages

- [Lazy](https://github.com/folke/lazy.nvim) - A modern plugin manager.
- [ayu](https://github.com/Shatur/neovim-ayu) - Simple theme with bright accents (dark/mirage/light); Lua port of ayu.
- [Oil](https://github.com/stevearc/oil.nvim) - File explorer (edit your filesystem like a buffer).
- [snacks.nvim](https://github.com/folke/snacks.nvim) - QoL suite: **picker** (find/grep/LSP), **indent** guides, **input**, **notifier** (LSP progress), **words** (reference highlight), bigfile.
- [blink.cmp](https://github.com/saghen/blink.cmp) - Fast completion engine with built-in fuzzy matching, snippets, signature help and icons.
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippet collection consumed by blink.
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close pairs.
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto-close/rename HTML/JSX tags.
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers.
- [lualine](https://github.com/nvim-lualine/lualine.nvim) - Statusline plugin written in lua.
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Parser generator and incremental parsing library (+ textobjects).
- [lsp-config](https://github.com/neovim/nvim-lspconfig) - Server configs for the native `vim.lsp` client.
- [mason](https://github.com/mason-org/mason.nvim) - Installer for LSP servers, formatters and linters.
- [conform](https://github.com/stevearc/conform.nvim) - A lightweight yet powerful formatter plugin.
- [navic](https://github.com/SmiteshP/nvim-navic) - Statusline component showing the current code context.
- [trouble](https://github.com/folke/trouble.nvim) - A pretty list for diagnostics, references, quickfix and location list.
- [bufferline](https://github.com/akinsho/bufferline.nvim) - A snazzy tab/buffer line for Neovim.
- [spectre](https://github.com/nvim-pack/nvim-spectre) - Project-wide find and replace.
- [tmux-navigator](https://github.com/alexghergh/nvim-tmux-navigation) - Seamless Neovim ⇄ Tmux pane navigation.

### Provided by Neovim built-ins (no plugin needed)

- **Commenting** — native `gc` / `gcc` (replaces Comment.nvim).
- **Folding** — `foldexpr = v:lua.vim.treesitter.foldexpr()` (replaces nvim-ufo).
- **Reference highlight / select UI / input UI** — handled by snacks (`words` / `picker.ui_select` / `input`).

# Keymaps

| Keymap         | Description                                           |
| -------------- | ----------------------------------------------------- |
| `<space>w`     | Save file.                                            |
| `<space>q`     | Quit file.                                            |
| `<space>o`     | Open Oil.                                             |
| `<space>sf`    | Search files (picker).                                |
| `<space>sg`    | Search by grep (picker).                              |
| `<space>/`     | Fuzzy search in current buffer (picker).             |
| `gcc` / `gc`   | Toggle comment (line / selection) — native.          |
| `<space>rn`    | Rename in current buffer (LSP).                       |
| `<space>ca`    | Code actions (LSP).                                   |
| `gd`           | Go to definition (LSP).                               |
| `gr`           | Go to references (picker).                            |
| `gi`           | Go to implementation (picker).                        |
| `<space>bs`    | Show buffer symbols (picker).                         |
| `<space>ps`    | Show project symbols (picker).                        |
| `K`            | Hover document (LSP).                                 |
| `<space>k`     | Signature documentation (LSP).                        |
| `gD`           | Go to declaration (LSP).                              |
| `td`           | Type definition (LSP).                                |
| `<space>S`     | Global find/replace.                                  |
| `<space>sw`    | Global find/replace for the word under the cursor.    |
| `<space>h`     | Screen horizontal split.                              |
| `<space>v`     | Screen vertical split.                                |
| `<space>f`     | Format document.                                      |
| `]d` / `[d`    | Go to next / previous diagnostic.                     |
| `]e` / `[e`    | Go to next / previous error diagnostic.              |
| `]w` / `[w`    | Go to next / previous warning diagnostic.            |
| `<space>d`     | Open the diagnostic under the cursor in float window. |
| `<space>td`    | Toggle document diagnostics (Trouble).               |
| `<space>tw`    | Toggle workspace diagnostics (Trouble).              |
| `<space>tq`    | Toggle quickfix list (Trouble).                      |
| `<space>tl`    | Toggle location list (Trouble).                      |
| `zr` / `zm`    | Open / close all folds.                               |
| `zo` / `zc`    | Open / close current fold.                            |
| `<space>gs`    | Open Git status (picker).                             |
| `<space>no`    | Turn off highlighted results.                         |
| `te` / `tc`    | Create / close tab.                                   |
| `tn` / `tp`    | Go to next / previous tab.                            |
| `<Tab>` / `<S-Tab>` | Cycle to next / previous buffer.                |
| `db`           | Delete other buffers but the current one.             |
| `lr`           | Restart LSP.                                          |

# Scaffolding

```
├── README.md
├── init.lua
├── lazy-lock.json
└── lua
    ├── core
    │   ├── init.lua
    │   ├── keymaps.lua
    │   ├── lazy.lua
    │   ├── options.lua
    │   └── utils.lua
    └── plugins
        ├── blink.lua
        ├── bufferline.lua
        ├── color_scheme.lua
        ├── gitsigns.lua
        ├── lsp.lua
        ├── lualine.lua
        ├── navic.lua
        ├── oil.lua
        ├── snacks.lua
        ├── spectre.lua
        ├── tmux_navigator.lua
        └── treesitter.lua
```
