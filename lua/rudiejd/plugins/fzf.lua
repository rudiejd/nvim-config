return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('fzf-lua').setup({})
        -- calling `setup` is optional for customization
        vim.keymap.set("n", "<c-P>",
          "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
        vim.keymap.set("n", "<c-S>",
          "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true })
    end,
}
