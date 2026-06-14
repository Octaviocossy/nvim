return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Install and manage LSP servers / tools
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Completion capabilities
			"saghen/blink.cmp",
		},
		config = function()
			-- ts_ls diagnostics to filter out
			local messages_to_filter = {
				"This may be converted to an async function.",
				"'_Assertion' is declared but never used.",
				"'__Assertion' is declared but never used.",
				"The signature '(data: string): string' of 'atob' is deprecated.",
				"The signature '(data: string): string' of 'btoa' is deprecated.",
			}

			-- Attach navic + buffer-local keymaps whenever a server attaches
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					-- Formatting is handled by conform, not the eslint LSP
					if client.name == "eslint" then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end

					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, event.buf)
					end

					require("core.keymaps").map_lsp_keybinds(event.buf)
				end,
			})

			-- Broadcast blink.cmp's extra completion capabilities to all servers
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- Per-server overrides, merged on top of nvim-lspconfig's defaults
			local servers = {
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
						},
					},
				},
				cssls = {},
				html = {},
				prismals = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find the Lua files loaded for your config
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							telemetry = { enabled = false },
						},
					},
				},
				eslint = {
					settings = {
						codeActionOnSave = {
							enable = true,
							mode = "all",
						},
						format = { enable = true },
						packageManager = "npm",
					},
				},
				ts_ls = {
					settings = {
						maxTsServerMemory = 12288,
					},
					handlers = {
						-- Drop a handful of noisy/irrelevant diagnostics
						["textDocument/publishDiagnostics"] = function(err, result, ctx)
							if result and result.diagnostics then
								result.diagnostics = vim.tbl_filter(function(diagnostic)
									return not vim.tbl_contains(messages_to_filter, diagnostic.message)
								end, result.diagnostics)
							end
							vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx)
						end,
					},
				},
			}

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end

			-- Mason installs the servers above + the formatters used by conform
			require("mason").setup({
				ui = { border = "rounded" },
			})
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = false, -- enabled explicitly below
			})
			require("mason-tool-installer").setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 12,
				ensure_installed = {
					"prettier",
					"eslint_d",
					"stylua",
					"black",
					"isort",
					"rustfmt",
					"goimports",
				},
			})

			vim.lsp.enable(vim.tbl_keys(servers))

			-- Diagnostics UI
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
				float = {
					border = "rounded",
					focusable = false,
					style = "minimal",
					source = true,
					header = "",
					prefix = "",
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			local eslint_files = {
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
			}

			local function get_js_formatters(bufnr)
				if vim.fs.find(eslint_files, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
					return { "eslint_d" }
				else
					return { "prettier" }
				end
			end

			require("conform").setup({
				formatters_by_ft = {
					javascript = get_js_formatters,
					javascriptreact = get_js_formatters,
					typescript = get_js_formatters,
					typescriptreact = get_js_formatters,
					vue = get_js_formatters,
					css = { "prettier" },
					scss = { "prettier" },
					less = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					handlebars = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					go = { "goimports", "gofmt" },
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble" },
		opts = {},
	},
}
