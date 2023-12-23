return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    dependencies = { 'nvim-lua/plenary.nvim', 'benfowler/telescope-luasnip.nvim'},
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
        vim.keymap.set('n', '<Leader>pr', builtin.lsp_references, {})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})


        local function send_current_buffer_to_qflist()
            local actions = require('telescope.actions')
            local current_bufnr = vim.api.nvim_get_current_buf()
            actions.send_to_qflist({prompt_bufnr = current_bufnr})
        end

        vim.keymap.set('n', '<C-q>', send_current_buffer_to_qflist, {})

        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                preview = {
                    treesitter = false
                }
            }
        })

        telescope.load_extension('luasnip')

        telescope.load_extension('projects')
    end
}
