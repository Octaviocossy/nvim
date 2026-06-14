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

					-- Formatting is handled by conform, not the eslint/biome LSP
					if client.name == "eslint" or client.name == "biome" then
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
				-- Lint + code actions for JS/TS/JSON/CSS. Auto-attaches only when
				-- the project has a biome.json/biome.jsonc; formatting is left to conform.
				biome = {},
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

			-- nvim-lspconfig lazy-loads on BufReadPost, so the buffer that triggered the
			-- load already fired FileType *before* vim.lsp.enable registered its autocmd.
			-- Re-emit FileType for loaded buffers so servers attach without a reload.
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
					vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
				end
			end

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
			local biome_files = { "biome.json", "biome.jsonc" }
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

			local function root_has(bufnr, files)
				return vim.fs.find(files, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] ~= nil
			end

			-- JS/TS: prefer Biome, then ESLint, else Prettier
			local function js_formatters(bufnr)
				if root_has(bufnr, biome_files) then
					return { "biome-check" }
				elseif root_has(bufnr, eslint_files) then
					return { "eslint_d" }
				else
					return { "prettier" }
				end
			end

			-- Vue: Biome's single-file-component support is partial, so keep ESLint/Prettier
			local function eslint_or_prettier(bufnr)
				return root_has(bufnr, eslint_files) and { "eslint_d" } or { "prettier" }
			end

			-- JSON / CSS: Biome when present, else Prettier
			local function biome_or_prettier(bufnr)
				return root_has(bufnr, biome_files) and { "biome-check" } or { "prettier" }
			end

			require("conform").setup({
				formatters_by_ft = {
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					vue = eslint_or_prettier,
					css = biome_or_prettier,
					scss = { "prettier" },
					less = { "prettier" },
					html = { "prettier" },
					json = biome_or_prettier,
					jsonc = biome_or_prettier,
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
