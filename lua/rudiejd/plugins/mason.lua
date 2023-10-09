local lsp_zero = require('lsp-zero')

return {
    {"williamboman/mason.nvim",
        config = function ()
            require('mason').setup()
        end
    },
    {"williamboman/mason-lspconfig.nvim",
        ensure_installed = {"lua_ls", "rust_analyzer", "csharp_ls"},
        handlers = {
            lsp_zero.default_setup
        },
        automatic_installation = true,
        config = function ()
           require('mason-lspconfig').setup()
        end
    }
}
