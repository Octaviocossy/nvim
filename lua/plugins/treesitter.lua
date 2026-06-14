return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- The actively-maintained rewrite, targeting Neovim 0.11+.
		-- (The old `master` branch is archived and errors on 0.12.)
		branch = "main",
		lazy = false, -- main does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"scss",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"vim",
				"prisma",
				"rust",
			})

			-- Enable highlighting + indentation per buffer once a parser exists
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- Select (visual + operator-pending)
			for lhs, obj in pairs({
				aa = "@parameter.outer",
				ia = "@parameter.inner",
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
			}) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(obj, "textobjects")
				end, { desc = "textobject " .. obj })
			end

			-- Movement
			local moves = {
				goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
				goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
				goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
				goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
			}
			for fn, maps in pairs(moves) do
				for lhs, obj in pairs(maps) do
					vim.keymap.set({ "n", "x", "o" }, lhs, function()
						move[fn](obj, "textobjects")
					end, { desc = fn .. " " .. obj })
				end
			end
		end,
	},
}
