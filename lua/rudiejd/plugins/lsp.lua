return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    -- allows for navigation of decompiled dependencies in C#
    -- {
    --     'Hoffs/omnisharp-extended-lsp.nvim',
    -- },
    {
        'Decodetalkers/csharpls-extended-lsp.nvim'
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'onsails/lspkind.nvim' },
            { 'hrsh7th/cmp-buffer' }
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- formatter config
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
                -- commenting this out for better performance
                -- lsp_zero.buffer_autoformat()
            end)


            -- autocomplete config
            lsp_zero.extend_cmp()

            local cmp = require('cmp')
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            local lspkind = require('lspkind')
            cmp.setup({
                formatting = { 
                    format = lspkind.cmp_format({
                          mode = 'symbol_text', -- show only symbol annotations
                          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                          -- The function below will be called before any actual modifications from lspkind
                          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                          -- before = function (entry, vim_item)
                          --   ...
                          --   return vim_item
                          -- end
                        })
                }, 
                mapping = {

                    -- i like enter better than ctrl - space for accepting completion
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },

                    -- supertab like configuration from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
                    ['<Tab>'] = function(fallback)
                        if not cmp.select_next_item() then
                            if vim.bo.buftype ~= 'prompt' and has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end,

                    ['<S-Tab>'] = function(fallback)
                        if not cmp.select_prev_item() then
                            if vim.bo.buftype ~= 'prompt' and has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end,
                    ['<C-Space>'] = function()
                        cmp.complete()
                    end
                },
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        cmp.config.compare.locality,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.score,
                        cmp.config.compare.offset,
                        cmp.config.compare.order,
                        cmp.config.compare.kind
                    }
                }
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
            { 'folke/neodev.nvim' },
            { 'ray-x/lsp_signature.nvim' }
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)


            local lspconfig = require('lspconfig')
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
            require('lspconfig').rust_analyzer.setup({})
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
                   local root_patterns = { '*.sln', '*.csproj', 'omnisharp.json', 'function.json' }
                   for _, pattern in ipairs(root_patterns) do
                     local found = util.root_pattern(pattern)(fname)
                     if found then
                       return found
                     end
                   end
                 end,
                 handlers = {
                     ["textDocument/definition"] = require('csharpls_extended').handler,
                     ["textDocument/typeDefinition"] = require('csharpls_extended').handler
                 }
             })

            -- python
            lspconfig.pyright.setup({})

            -- f#
            lspconfig.fsautocomplete.setup({})

            -- C++
            lspconfig.clangd.setup({})

            -- signature help when entering a function
            require('lsp_signature').setup({})
        end
    },
}
