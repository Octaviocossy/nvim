local status_ok, spectre = pcall(require, "spectre")

if not status_ok then
	return
end

spectre.setup()

vim.keymap.set("n", "<Leader>r", "<cmd>Spectre<cr><C-w>w")
