return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'VonHeikemen/lsp-zero.nvim' },
    ensure_installed = { 'lua_ls', 'rust_analyzer', 'csharp-ls', 'netcoredbg' },
    automatic_installation = true,
  },
}
