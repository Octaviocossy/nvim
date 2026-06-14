return {
	-- Completion engine (replaces nvim-cmp + cmp sources + LuaSnip + lspkind)
	{
		"saghen/blink.cmp",
		version = "*", -- use a release tag so the prebuilt fuzzy binary is downloaded
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			-- Built-in kind icons (replaces lspkind.nvim)
			appearance = {
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			-- Native vim.snippet + friendly-snippets (replaces LuaSnip)
			snippets = {
				preset = "default",
			},
			-- Inline signature help while typing (replaces the insert-mode <C-k> map)
			signature = {
				enabled = true,
			},
			completion = {
				ghost_text = { enabled = true },
				menu = { border = "rounded" },
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
			},
			keymap = {
				preset = "none",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-c>"] = { "cancel", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
		},
	},

	-- Auto-close/rename pairs and HTML/JSX tags (moved out of the old cmp spec
	-- so nvim-ts-autotag is actually set up — it was a no-op under treesitter)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
