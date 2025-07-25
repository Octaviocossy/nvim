return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Plugin(s) and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Install lsp autocompletions
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local map_lsp_keybinds = require("core.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

			-- Override tsserver diagnostics to filter out specific messages
			local messages_to_filter = {
				"This may be converted to an async function.",
				"'_Assertion' is declared but never used.",
				"'__Assertion' is declared but never used.",
				"The signature '(data: string): string' of 'atob' is deprecated.",
				"The signature '(data: string): string' of 'btoa' is deprecated.",
			}

			local function tsserver_on_publish_diagnostics_override(_, result, ctx, config)
				local filtered_diagnostics = {}

				for _, diagnostic in ipairs(result.diagnostics) do
					local found = false
					for _, message in ipairs(messages_to_filter) do
						if diagnostic.message == message then
							found = true
							break
						end
					end
					if not found then
						table.insert(filtered_diagnostics, diagnostic)
					end
				end

				result.diagnostics = filtered_diagnostics

				vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
			end

			-- Default handlers for LSP
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			-- Function to run when neovim connects to a Lsp client
			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				--
				if _client.supports_method("textDocument/documentSymbol") then
					require("nvim-navic").attach(_client, buffer_number)
				end

				map_lsp_keybinds(buffer_number)
			end

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP Specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- LSP servers to install (see list here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers )
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- LSP Servers
				rust_analyzer = {
					cargo = {
						allFeatures = true,
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
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							telemetry = { enabled = false },
						},
					},
				},
				eslint_lsp = {
					settings = {
						codeActionOnSave = {
							enable = true,
							mode = "all",
						},
						format = { enable = true },
						packageManager = "npm",
					},
					on_attach = function(client, bufnr)
						-- Deshabilitar formateo de eslint LSP ya que usamos conform
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				},
				ts_ls = {
					settings = {
						maxTsServerMemory = 12288,
					},
					handlers = {
						["textDocument/publishDiagnostics"] = vim.lsp.with(
							tsserver_on_publish_diagnostics_override,
							{}
						),
					},
				},
			}

			local ensure_installed = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers))

			require("mason-tool-installer").setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 12,
				ensure_installed = vim.tbl_extend("force", ensure_installed, {
					-- Formatters para conform.nvim
					"prettier",
					"eslint_d",
					"eslint-lsp",
					"stylua",
					"black",
					"isort",
					"rustfmt",
					"goimports",
				}),
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
					on_attach = on_attach,
					settings = config.settings,
				})
			end

			-- angularls custom config
			-- local install_path = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules"
			-- local ang = install_path .. "/@angular/language-server/node_modules"
			--
			-- local cmd = {
			--   "ngserver",
			--   "--stdio",
			--   "--tsProbeLocations",
			--   install_path,
			--   "--ngProbeLocations",
			--   ang,
			-- }
			--
			-- require("lspconfig").angularls.setup({
			--   on_attach = on_attach,
			--   cmd = cmd,
			--   on_new_config = function(new_config)
			--     new_config.cmd = cmd
			--   end,
			-- })

			-- Setup mason so it can manage 3rd party LSP servers
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			require("mason-lspconfig").setup()

			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagnostics with enhanced visualization
			vim.diagnostic.config({
				-- Enable virtual text (diagnostics inline)
				virtual_text = {
					enabled = true,
					spacing = 4,
					source = "if_many",
					prefix = "●",
					severity = {
						min = vim.diagnostic.severity.HINT,
					},
				},
				-- Configure signs in the sign column
				signs = {
					active = true,
					values = {
						{ name = "DiagnosticSignError", text = " " },
						{ name = "DiagnosticSignWarn", text = " " },
						{ name = "DiagnosticSignHint", text = " " },
						{ name = "DiagnosticSignInfo", text = " " },
					},
				},
				-- Configure float window
				float = {
					border = "rounded",
					focusable = false,
					style = "minimal",
					source = true,
					header = "",
					prefix = "",
				},
				-- Configure underline
				underline = {
					enabled = true,
					severity = {
						min = vim.diagnostic.severity.HINT,
					},
				},
				-- Configure update in insert mode
				update_in_insert = false,
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
		cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
