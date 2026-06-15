return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Performance for very large files
			bigfile = { enabled = true },
			-- File explorer (replaces oil); also hijacks netrw for opening directories
			explorer = { enabled = true, replace_netrw = true },
			-- Inline image rendering (needs ImageMagick + a kitty-graphics terminal, e.g. Ghostty)
			image = { enabled = true },
			-- Indent guides + current scope (replaces indent-blankline + mini.indentscope)
			indent = {
				enabled = true,
				indent = { char = "│" },
				scope = { char = "│" },
			},
			-- Better vim.ui.input (replaces dressing.nvim)
			input = { enabled = true },
			-- Notifications + LSP progress (replaces fidget.nvim)
			notifier = { enabled = true },
			-- Fuzzy picker (replaces telescope.nvim)
			picker = {
				enabled = true,
				ui_select = true, -- route vim.ui.select through the picker
				sources = {
					explorer = {
						-- show the file explorer on the right
						layout = { layout = { position = "right", width = 65 } },
						-- show dotfiles and gitignored files by default (toggle with `.` / `i`)
						hidden = true,
						ignored = true,
					},
				},
			},
			-- Highlight references of the word under the cursor (replaces vim-illuminate)
			words = { enabled = true },
		},
	},
}
