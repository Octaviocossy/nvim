return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Performance for very large files
			bigfile = { enabled = true },
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
			},
			-- Highlight references of the word under the cursor (replaces vim-illuminate)
			words = { enabled = true },
		},
	},
}
