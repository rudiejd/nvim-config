return {
    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim", 'VonHeikemen/lsp-zero.nvim'},
        ensure_installed = { "lua_ls", "rust_analyzer", "csharp-ls", "netcoredbg" },
        handlers = {
            require('lsp-zero').default_setup
        },
        automatic_installation = true,
        config = function()
            require('mason-lspconfig').setup()
        end
    }
}
