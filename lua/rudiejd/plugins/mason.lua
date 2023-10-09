local lsp_zero = require('lsp-zero')

return {
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim", 
        ensure_installed = {"lua_ls", "rust_analyzer", "csharp_ls"},
        handlers = {
            lsp_zero.default_setup
        },
        automatic_installation = true
    }
}
