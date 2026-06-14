local nnoremap = require("core.utils").keymap_nnoremap
local _nnoremap = require("core.utils").keymap_nmap

local M = {}

-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Delete other buffers but the current one
nnoremap("<leader>db", '<Esc>:%bdelete|edit #|normal`"<Return>', { desc = "Delete other buffers but the current one" })

-- Restart LSP
nnoremap("<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Save with leader key
nnoremap("<leader>w", "<cmd>w!<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q!<cr>", { silent = false })

-- File explorer (snacks)
nnoremap("<leader>o", function()
  Snacks.explorer()
end, { desc = "File explorer" })

-- Picker (snacks)
nnoremap("<leader>sf", function()
  Snacks.picker.files()
end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "[S]earch by [G]rep" })
nnoremap("<leader>/", function()
  Snacks.picker.lines()
end, { desc = "[/] Fuzzily search in current buffer]" })

-- LSP
M.map_lsp_keybinds = function(buffer_number)
  nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
  nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

  nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

  -- Picker (snacks) LSP keybinds --
  nnoremap("gr", function()
    Snacks.picker.lsp_references()
  end, { desc = "LSP: [G]oto [R]eferences", buffer = buffer_number })

  nnoremap("gi", function()
    Snacks.picker.lsp_implementations()
  end, { desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number })

  nnoremap("<leader>bs", function()
    Snacks.picker.lsp_symbols()
  end, { desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number })

  nnoremap("<leader>ps", function()
    Snacks.picker.lsp_workspace_symbols()
  end, { desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number })

  -- See `:help K` for why this keymap
  nnoremap("K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, { desc = "LSP: Hover Documentation", buffer = buffer_number })
  nnoremap("<leader>k", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, { desc = "LSP: Signature Documentation", buffer = buffer_number })

  -- Lesser used LSP functionality
  nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
  nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

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
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })

-- Goto next diagnostic of any severity
nnoremap("]d", function()
  vim.diagnostic.goto_next({})
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
  vim.diagnostic.goto_prev({})
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Open the diagnostic under the cursor in a float window
nnoremap("<leader>d", function()
  vim.diagnostic.open_float({
    border = "rounded",
  })
end)

-- Trouble diagnostics / lists
nnoremap("<leader>td", function()
  require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { desc = "Toggle document diagnostics" })

nnoremap("<leader>tw", function()
  require("trouble").toggle({ mode = "diagnostics" })
end, { desc = "Toggle workspace diagnostics" })

nnoremap("<leader>tq", function()
  require("trouble").toggle({ mode = "qflist" })
end, { desc = "Toggle quickfix list" })

nnoremap("<leader>tl", function()
  require("trouble").toggle({ mode = "loclist" })
end, { desc = "Toggle location list" })

-- Folding (native treesitter foldexpr)
nnoremap("zr", "zR", { desc = "Open all folds" })
nnoremap("zm", "zM", { desc = "Close all folds" })

-- Git keymaps --
nnoremap("<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })

-- Bufferline
nnoremap("te", ":tabnew<cr>")
nnoremap("tc", ":tabclose<cr>")
nnoremap("tn", ":tabnext<cr>")
nnoremap("tp", ":tabprevious<cr>")

_nnoremap("<Tab>", ":BufferLineCycleNext<cr>")
_nnoremap("<S-Tab>", ":BufferLineCyclePrev<cr>")

-- Turn off highlighted results
nnoremap("<leader>no", "<cmd>noh<cr>")

return M
