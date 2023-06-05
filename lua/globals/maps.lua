local keymap = vim.keymap

-- Save / Close file

keymap.set("n", "<Leader>w", ":w!<Return>")
keymap.set("n", "<Leader>q", ":q!<Return>")

-- Tabs

keymap.set("n", "te", ":tabnew<Return>")
keymap.set("n", "tc", ":tabclose<Return>")
keymap.set("n", "tn", ":tabnext<Return>")
keymap.set("n", "tp", ":tabprevious<Return>")

-- Split Window

keymap.set("n", "sh", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")
