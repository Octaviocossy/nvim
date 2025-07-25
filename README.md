# Dependencies

**_Neovim:_** `brew install --HEAD neovim` <br/>
**_Eslint:_** `npm install -g eslint_d` <br/>
**_Prettier:_** `npm install -g prettier` <br/>
**_Stylua:_** `brew install -g stylua` <br/>
**_ripgrep:_** `brew install ripgrep` <br/>

## WSL dependencies:

**_GCC:_** `sudo apt install build-essential`

# Packages

- [Lazy](https://github.com/folke/lazy.nvim) - A modern plugin manager.
- [Catppuccin](https://github.com/catppuccin/nvim) -  Soothing pastel theme.
- [Oil](https://github.com/stevearc/oil.nvim) -  File explorer.
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) -  Find, Filter, Preview, Pick. All lua, all the time.
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers.
- [lualine](https://github.com/nvim-lualine/lualine.nvim) - Statusline plugin written in lua.
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - A parser generator tool and an incremental parsing library.
- [lsp-config](https://github.com/neovim/nvim-lspconfig) - Quickstart configs for Nvim LSP.
- [cmp](https://github.com/hrsh7th/nvim-cmp) - A completion plugin coded in Lua.
- [copilot](https://github.com/zbirenbaum/copilot.lua) - Pure lua replacement for [github/copilot.vim](https://github.com/github/copilot.vim).
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) -  Turn github copilot into a cmp source.
- [ident-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides for Neovim.
- [spectre](https://github.com/nvim-pack/nvim-spectre) - Find and replace.
- [tmux-navigator](https://github.com/alexghergh/nvim-tmux-navigation) - Easy Neovim-Tmux navigation, completely written in Lua.
- [symbols-outline](https://github.com/simrat39/symbols-outline.nvim) - A tree like view for symbols in Neovim.
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) -  Make Neovim's fold look modern and keep high performance.
- [dressing](https://github.com/stevearc/dressing.nvim) -  Improve the default vim.ui interfaces.
- [vim-illuminate](https://github.com/RRethy/vim-illuminate) - Automatically highlighting other uses of the word under the cursor.
- [mini-ident-scope](https://github.com/echasnovski/mini.indentscope) - Plugin to visualize and operate on indent scope.
- [comment](https://github.com/numToStr/Comment.nvim) -  Smart and powerful comment plugin for neovim.
- [fidget](https://github.com/j-hui/fidget.nvim) - Extensible UI for Neovim notifications and LSP progress messages..
- [NeoTree](https://github.com/nvim-neo-tree/neo-tree.nvim) - Neovim plugin to manage the file system and other tree like structures.
- [diffview](https://github.com/sindrets/diffview.nvim) - Single tabpage interface for easily cycling through diffs.
- [bufferline](https://github.com/akinsho/bufferline.nvim) - A snazzy bufferline for Neovim.
- [conform](https://github.com/stevearc/conform.nvim) - A lightweight yet powerful formatter plugin for Neovim.
- [navic](https://github.com/SmiteshP/nvim-navic) - Statusline plugin that shows your current code context.
- [trouble](https://github.com/folke/trouble.nvim) - A beautiful diagnostics, references, telescope results, quickfix and location list.

# Keymaps

| Keymap         | Description                                           |
| -------------- | ----------------------------------------------------- |
| `<space>w`     | Save file.                                            |
| `<space>q`<br> | Quit file.                                            |
| `<space>o`     | Open Oil.                                             |
| `<space>sf`    | Search files (Telescope).<br>                         |
| `<space>sg`    | Search file by grep (Telescope).                      |
| `<space>/`     | Search worlds in current buffer (Telescope).          |
| `<space>rn`    | Rename in current buffer (LSP).                       |
| `<space>ca`    | Code actions (LSP).                                   |
| `gd`           | Go to definition (LSP).                               |
| `gr`           | Go to reference (LSP).                                |
| `gi`           | Go to implementation (LSP),                           |
| `<space>bs`    | Show buffer symbols (LSP),                            |
| `<space>ps`    | Show project symbols (LSP),                           |
| `K`            | Hover document (LSP).                                 |
| `<space>k`     | Signature Documentation (LSP).                        |
| `gD`           | Go to declaration (LSP).                              |
| `td`           | Type definition (LSP).                                |
| `<space>S`     | Global find/replace.                                  |
| `<space>sw`    | Global find/replace for the word under the cursor.    |
| `<space>h`     | Screen horizontal split.                              |
| `<space>v`     | Screen vertical split.                                |
| `<space>f`     | Format document.                                      |
| `]d`           | Go to next diagnostic.                                |
| `[d`           | Go to previous diagnostic.                            |
| `]e`           | Go to next error diagnostic.                          |
| `[e`           | Go to previous error diagnostic.                      |
| `]w`           | Go to next warning diagnostic.                        |
| `[w`           | Go to previous warning diagnostic.                    |
| `<space>d`     | Open the diagnostic under the cursor in float window. |
| `<space>td`    | Toggle document diagnostics window (Trouble).        |
| `<space>tw`    | Toggle workspace diagnostics window (Trouble).       |
| `<space>tq`    | Toggle quickfix list (Trouble).                      |
| `<space>tl`    | Toggle location list (Trouble).                      |
| `zr`           | Open all folds.                                       |
| `zm`           | Close all folds.                                      |
| `zo`           | Open current fold.                                    |
| `zc`           | Close current fold.                                   |
| `<space>gs`    | Open DiffView.                                        |
| `<space>no`    | Turn off highlighted results.                         |
| `te`           | Create new tab.                                       |
| `tc`           | Close current tab.                                    |
| `tn`           | Go to next tab.                                       |
| `tp`           | Go to previous tab.                                   |
| `db`           | Delete other buffers but the current one.             |
| `lr`           | Restart LSP.                                          |

# Scaffolding

```
├── README.md
├── init.lua
└── lua
    ├── core
    │   ├── editor_config.lua
    │   ├── init.lua
    │   ├── keymaps.lua
    │   ├── lazy.lua
    │   ├── options.lua
    │   ├── user_commands.lua
    │   └── utils.lua
    └── plugins
        ├── bufferline.lua
        ├── cmp.lua
        ├── color_scheme.lua
        ├── comment.lua
        ├── copilot.lua
        ├── diffview.lua
        ├── dressing.lua
        ├── gitsigns.lua
        ├── ident_blankline.lua
        ├── lsp.lua
        ├── lualine.lua
        ├── mini_indentscope.lua
        ├── navic.lua
        ├── neotree.lua
        ├── fidget.lua
        ├── oil.lua
        ├── spectre.lua
        ├── symbols_outline.lua
        ├── telescope.lua
        ├── tmux_navigator.lua
        ├── treesitter.lua
        ├── ufo.lua
        └── vim_illuminate.lua
```
