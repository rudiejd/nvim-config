return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        { 'L3MON4D3/LuaSnip' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'onsails/lspkind.nvim' },
        { 'hrsh7th/cmp-buffer' },
        { 'rcarriga/cmp-dap' },
    },
    config = function()
        local lsp_zero = require('lsp-zero')
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
        lspkind.init({
        })

        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

        local luasnip = require('luasnip')
        cmp.setup({
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',  -- show only symbol annotations
                    maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    symbol_map = {
                        Copilot = "∩äô",
                    },

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    -- before = function (entry, vim_item)
                    --   ...
                    --   return vim_item
                    -- end
                })
            },
            mapping = {
                -- supertab like configuration from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                -- force a completion
                ['<C-Space>'] = function()
                    cmp.complete()
                end,

                -- early confirm a completion
                ['<C-y>'] = cmp.mapping.confirm {
                    select = false
                }
                --
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
            },
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                    or require("cmp_dap").is_dap_buffer()
            end,
            sources = {
                { name = "luasnip",  group_index = 2 },
                { name = "copilot",  group_index = 2 },
                { name = "nvim_lsp", group_index = 2 },
                { name = "path",     group_index = 2 },
            },
            experimental = {
                ghost_text = true
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            }
        })

        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
                { name = "dap" },
            },
        })
    end
}
