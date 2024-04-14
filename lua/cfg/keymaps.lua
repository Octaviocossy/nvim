local nnoremap = require("cfg.utils").keymap_nnoremap

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")
--
-- Save with leader key
nnoremap("<leader>w", "<cmd>w!<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q!<cr>", { silent = false })

-- Oil
nnoremap("<leader>e", function() require("oil").toggle_float() end)

-- Telescope
nnoremap("<leader>sf", function() require("telescope.builtin").find_files({ hidden = true }) end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sg", function() require("telescope.builtin").live_grep() end, { desc = "[S]earch by [G]rep" })
