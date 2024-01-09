return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
			{ "folke/neodev.nvim" },
			{ "Decodetalkers/csharpls-extended-lsp.nvim" },
			{ "jmederosalvarado/roslyn.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			-- formatter config
			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
				--- toggle inlay hints
				vim.g.inlay_hints_visible = false
				local function toggle_inlay_hints()
					if vim.g.inlay_hints_visible then
						vim.g.inlay_hints_visible = false
						vim.lsp.inlay_hint(bufnr, false)
					else
						if client.server_capabilities.inlayHintProvider then
							vim.g.inlay_hints_visible = true
							vim.lsp.inlay_hint(bufnr, true)
						else
							print("no inlay hints available")
						end
					end
				end

				-- inlay hints
				vim.keymap.set("n", "<leader>ih", toggle_inlay_hints)

				-- run the edit command after the lsp is intiialized for semantic higlighting
				-- this didn't work :(
				-- if client.name == "csharp-ls" then
				--     print(vim.inspect(client))
				--     vim.cmd("e!")
				-- end

				-- commenting this out for better performance
				-- lsp_zero.buffer_autoformat()
			end)

			require("neodev").setup({})

			local lspconfig = require("lspconfig")
			-- (Optional) Configure lua language server for neovim
			local lua_opts = lsp_zero.nvim_lua_ls()
			lspconfig.lua_ls.setup(lua_opts)
			require("lspconfig").rust_analyzer.setup({})
			-- lspconfig.omnisharp.setup({
			--     handlers = {
			--         ["textDocument/definition"] = require('omnisharp_extended').handler,
			--         ["textDocument/publishDiagnostic"] = vim.lsp.with(
			--             vim.lsp.diagnostic.on_publish_diagnostics, {
			--                 underline = true,
			--                 update_in_insert = true,
			--                 signs = true,
			--                 virtual_text = false,
			--             }
			--         )
			--     },
			--     cmd = { "omnisharp" }
			-- })

			local util = lspconfig.util
			lspconfig.csharp_ls.setup({
				root_dir = function(fname)
					local root_patterns = { "*.sln", "*.csproj", "omnisharp.json", "function.json" }
					for _, pattern in ipairs(root_patterns) do
						local found = util.root_pattern(pattern)(fname)
						if found then
							return found
						end
					end
				end,
				handlers = {
					["textDocument/definition"] = require("csharpls_extended").handler,
					["textDocument/implementation"] = require("csharpls_extended").handler,
					["textDocument/typeDefinition"] = require("csharpls_extended").handler,
				},
				-- hack to make it attach on BufEnter
				filetypes = {},
			})

			-- python
			lspconfig.pyright.setup({})
			lspconfig.pyright.before_init = function(params, config)
				local Path = require("plenary.path")
				local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
				if venv:joinpath("bin"):is_dir() then
					config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
				else
					config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
				end
			end

			-- -- f# (replaced with ionide)
			-- lspconfig.fsautocomplete.setup({})

			-- C++
			lspconfig.clangd.setup({})

			-- ocaml
			lspconfig.ocamllsp.setup({})

			-- JS/TS
			lspconfig.tsserver.setup({})

			lspconfig.eslint.setup({
				-- not sure if I like this yet
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
				-- this isn't the default, but that one seemed slow
				root_dir = util.find_git_ancestor,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
					"svelte",
					"astro",
				},
			})

			-- SQLs
			lspconfig.sqlls.setup({})

			-- Docker
			lspconfig.dockerls.setup({})
			lspconfig.docker_compose_language_service.setup({})

			-- Java
			lspconfig.jdtls.setup({})

			-- YAML . I currenlty only use kuberneses YAML, so everything uses that schmea
			lspconfig.yamlls.setup({
				settings = {
					schemas = {
						["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.yaml",
					},
					redhat = {
						telemetry = {
							enabled = false,
						},
					},
					single_file_support = true,
					filetypes = { "yaml", "yaml.docker-compose" },
					root_dir = util.find_git_ancestor,
				},
			})

			-- Tilt files (https://tilt.dev)
			lspconfig.tilt_ls.setup({})
			-- bash
			lspconfig.bashls.setup({})

			-- cmake
			lspconfig.neocmake.setup({})

			-- Go
			lspconfig.gopls.setup({})
		end,
	},
}
