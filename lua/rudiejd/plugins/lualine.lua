local show_neotest_statuses = function()
  local neotest = require('neotest')
  local primary_adapter = neotest.state.adapter_ids()[1]
  local statuses = neotest.state.status_counts(primary_adapter)
  return tostring(statuses.passed) .. "✅/" .. tostring(statuses.total)
end

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- allows for base16 color schemes
  dependencies = {
    'RRethy/nvim-base16',
  },
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = 'base16',
      component_separators = '|',
      section_separators = '',
    },
  },
  config = function()
    require('base16-colorscheme').with_config {
      telescope = true,
      indentblankline = true,
      notify = true,
      ts_rainbow = true,
      cmp = true,
      illuminate = true,
    }

    -- default config
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { {show_neotest_statuses, color = 'WarningMsg'}},
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
