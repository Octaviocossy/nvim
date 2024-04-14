local nnoremap = require("cfg.utils").keymap_nnoremap
local inoremap = require("cfg.utils").keymap_inoremap

local M = {}

-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")
--
-- Save with leader key
nnoremap("<leader>w", "<cmd>w!<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q!<cr>", { silent = false })

-- Oil
nnoremap("<leader>e", function()
  require("oil").toggle_float()
end)

-- Telescope
nnoremap("<leader>sf", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sg", function()
  require("telescope.builtin").live_grep()
end, { desc = "[S]earch by [G]rep" })
nnoremap("<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- LSP
M.map_lsp_keybinds = function(buffer_number)
  nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
  nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

  nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

  -- Telescope LSP keybinds --
  nnoremap("gr", require("telescope.builtin").lsp_references, { desc = "LSP: [G]oto [R]eferences", buffer = buffer_number })

  nnoremap("gi", require("telescope.builtin").lsp_implementations, { desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number })

  nnoremap("<leader>bs", require("telescope.builtin").lsp_document_symbols, { desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number })

  nnoremap("<leader>ps", require("telescope.builtin").lsp_workspace_symbols, { desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number })

  -- See `:help K` for why this keymap
  nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
  nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
  inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

  -- Lesser used LSP functionality
  nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
  nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

-- Symbol Outline keybind
nnoremap("<leader>so", ":SymbolsOutline<cr>")

-- Spectre
-- Open for global find/replace
nnoremap("<leader>S", function()
  require("spectre").toggle()
end)

-- Open for global find/replace for the word under the cursor in normal mode
nnoremap("<leader>sw", function()
  require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })

-- Split windows
nnoremap("<leader>h", "<cmd>split<cr><C-w>w")
nnoremap("<leader>v", "<cmd>vsplit<cr><C-w>w")

-- Move through the windows
nnoremap("<C-h>", function()
  require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
end, { desc = "Move to left panel" })

nnoremap("<C-j>", function()
  require("nvim-tmux-navigation").NvimTmuxNavigateDown()
end, { desc = "Move to down panel" })

nnoremap("<C-k>", function()
  require("nvim-tmux-navigation").NvimTmuxNavigateUp()
end, { desc = "Move to up panel" })

nnoremap("<C-l>", function()
  require("nvim-tmux-navigation").NvimTmuxNavigateRight()
end, { desc = "Move to right panel" })

-- Press leader f to format
nnoremap("<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format the current buffer" })

return M
