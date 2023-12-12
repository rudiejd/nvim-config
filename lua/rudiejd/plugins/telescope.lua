return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
        vim.keymap.set('n', '<Leader>pr', builtin.lsp_references, {})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        require('telescope').setup({
            defaults = {
                preview = {
                    treesitter = false
                }
            }
        })
    end
}
