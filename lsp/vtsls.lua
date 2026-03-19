vim.lsp.config('vtsls', {
  cmd = {"vtsls", "--stdio"},
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})
