local keymap = vim.keymap

-- Save / Close file
keymap.set("n", "<Leader>w", "<cmd>w<cr><esc>")
keymap.set("n", "<Leader>q", "<cmd>q<cr><esc>")

-- Tabs
keymap.set("n", "te", ":tabnew<Return>")
keymap.set("n", "tc", ":tabclose<Return>")
keymap.set("n", "tn", ":tabnext<Return>")
keymap.set("n", "tp", ":tabprevious<Return>")

-- Split Window
keymap.set("n", "sh", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")
