return {
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          c = { 'clang-format' },
          cpp = { 'clang-format' },
          python = { 'ruff' },
          terraform = { 'tofu_fmt' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = 'fallback',
        },
      }
    end,
  },
}
