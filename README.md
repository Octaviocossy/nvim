# Neovim

A minimal, modern Neovim configuration for **Neovim ≥ 0.11** — native LSP, Treesitter,
and a small set of well-integrated plugins managed by
[lazy.nvim](https://github.com/folke/lazy.nvim). Developed on 0.12.

## Requirements

| Tool              | Install                          | Used for                          |
| ----------------- | -------------------------------- | --------------------------------- |
| Neovim ≥ 0.11     | `brew install neovim`            | native LSP, folding, commenting   |
| ripgrep           | `brew install ripgrep`           | live grep in the picker           |
| tree-sitter CLI   | `npm install -g tree-sitter-cli` | building Treesitter parsers       |
| C compiler        | `xcode-select --install`         | compiling parsers                 |
| fd                | `brew install fd`                | file finding in explorer & picker |
| ImageMagick       | `brew install imagemagick`       | inline image rendering (snacks.image) |

> **WSL:** install a compiler with `sudo apt install build-essential`.

LSP servers and formatters install automatically via
[mason](https://github.com/mason-org/mason.nvim) on first launch (prettier, eslint_d,
stylua, black, isort, rustfmt, goimports, biome, …). JS/TS/JSON/CSS tooling is
**project-aware**: when a `biome.json` is present, Biome handles formatting (conform) and
linting/code-actions (its LSP); otherwise it falls back to ESLint/Prettier.

> **Images:** snacks.image needs a terminal with the Kitty graphics protocol — Ghostty, kitty or WezTerm.

## Install

```sh
git clone https://github.com/Octaviocossy/nvim.git ~/.config/nvim
nvim
```

First launch installs the plugins (lazy.nvim) and tools (mason) — restart Neovim once it finishes.

## Plugins

**Manager** — [lazy.nvim](https://github.com/folke/lazy.nvim)

**UI & quality-of-life**

- [ayu](https://github.com/Shatur/neovim-ayu) — color scheme (dark/mirage/light).
- [lualine](https://github.com/nvim-lualine/lualine.nvim) — statusline.
- [bufferline](https://github.com/akinsho/bufferline.nvim) — tab / buffer line.
- [navic](https://github.com/SmiteshP/nvim-navic) — code-context breadcrumbs in the statusline.
- [snacks.nvim](https://github.com/folke/snacks.nvim) — picker (find/grep/LSP), file explorer, image rendering, indent guides, input, notifier (LSP progress), word highlight, bigfile.

**Editing**

- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — parsing, highlighting, indentation, textobjects.
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) — auto-close pairs.
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) — auto-close / rename HTML & JSX tags.
- [spectre](https://github.com/nvim-pack/nvim-spectre) — project-wide find & replace.

**LSP, completion & formatting**

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — server configs for the native `vim.lsp` client.
- [mason](https://github.com/mason-org/mason.nvim) — installs LSP servers, formatters and linters.
- [blink.cmp](https://github.com/saghen/blink.cmp) — completion: fuzzy matching, snippets, signature help, icons.
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) — snippet collection for blink.
- [conform](https://github.com/stevearc/conform.nvim) — formatter runner.
- [trouble](https://github.com/folke/trouble.nvim) — diagnostics, references and quickfix list.

**Git & navigation**

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) — git signs in the buffer.
- [tmux-navigator](https://github.com/alexghergh/nvim-tmux-navigation) — seamless Neovim ⇄ tmux pane movement.

> Some features use **Neovim built-ins** rather than plugins: commenting (`gc` / `gcc`),
> folding (Treesitter `foldexpr`), and `vim.ui` select / input (snacks).

## Keymaps

> Leader key is `<Space>`.

### General

| Key                       | Action                               |
| ------------------------- | ------------------------------------ |
| `<leader>w` / `<leader>q` | Save / quit                          |
| `<leader>f`               | Format buffer                        |
| `<leader>no`              | Clear search highlight               |
| `lr`                      | Restart LSP                          |
| `db`                      | Delete all buffers except current    |

### Files & search

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<leader>e`  | Open file explorer                  |
| `<leader>sf` | Find files                          |
| `<leader>sg` | Live grep                           |
| `<leader>/`  | Fuzzy-find in current buffer        |
| `<leader>S`  | Project-wide find & replace         |
| `<leader>sw` | Find & replace word under cursor    |
| `<leader>gs` | Git status                          |

### LSP

| Key                          | Action                          |
| ---------------------------- | ------------------------------- |
| `gd` / `gD`                  | Go to definition / declaration  |
| `gr` / `gi`                  | Go to references / implementations |
| `td`                         | Type definition                 |
| `K` / `<leader>k`            | Hover / signature help          |
| `<leader>rn`                 | Rename                          |
| `<leader>ca`                 | Code action                     |
| `<leader>bs` / `<leader>ps`  | Document / workspace symbols     |

### Diagnostics & Trouble

| Key                          | Action                                |
| ---------------------------- | ------------------------------------- |
| `]d` / `[d`                  | Next / previous diagnostic            |
| `]e` / `[e`                  | Next / previous error                 |
| `]w` / `[w`                  | Next / previous warning               |
| `<leader>d`                  | Show diagnostic in a float            |
| `<leader>td` / `<leader>tw`  | Document / workspace diagnostics      |
| `<leader>tq` / `<leader>tl`  | Quickfix / location list              |

### Folds

| Key         | Action                          |
| ----------- | ------------------------------- |
| `zr` / `zm` | Open / close all folds          |
| `zo` / `zc` | Open / close fold under cursor  |

### Windows, tabs & buffers

| Key                       | Action                            |
| ------------------------- | --------------------------------- |
| `<leader>h` / `<leader>v` | Horizontal / vertical split       |
| `<C-h/j/k/l>`             | Move between splits / tmux panes  |
| `te` / `tc`               | New / close tab                   |
| `tn` / `tp`               | Next / previous tab               |
| `<Tab>` / `<S-Tab>`       | Next / previous buffer            |

### Editing

| Key            | Action                            |
| -------------- | --------------------------------- |
| `gcc` / `gc`   | Toggle comment (line / selection) |

### Completion — insert mode (blink.cmp)

| Key                 | Action                              |
| ------------------- | ----------------------------------- |
| `<C-j>` / `<C-k>`   | Next / previous item                |
| `<Tab>` / `<S-Tab>` | Next item or jump snippet / reverse |
| `<C-Space>`         | Open menu / toggle docs             |
| `<C-u>` / `<C-d>`   | Scroll docs                         |
| `<CR>` / `<C-c>`    | Accept / cancel                     |

### Treesitter textobjects — visual / operator-pending

| Key         | Textobject                       |
| ----------- | -------------------------------- |
| `af` / `if` | a / inner function               |
| `ac` / `ic` | a / inner class                  |
| `aa` / `ia` | a / inner parameter              |
| `]m` / `[m` | Next / previous function start   |
| `]]` / `[[` | Next / previous class start      |

## Structure

```
~/.config/nvim
├── init.lua            # entry point → require("core")
├── lazy-lock.json      # pinned plugin versions
└── lua/
    ├── core/           # loaded in order by core/init.lua
    │   ├── options.lua  #   vim options
    │   ├── keymaps.lua  #   all keymaps (incl. the LSP keymaps)
    │   ├── lazy.lua     #   bootstraps lazy.nvim, imports plugins/
    │   └── utils.lua    #   keymap helpers
    └── plugins/        # one file per plugin spec (auto-imported)
```
