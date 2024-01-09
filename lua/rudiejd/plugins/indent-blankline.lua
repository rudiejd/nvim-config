return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {},
  configure = function()
    require('ibl').setup()
  end,
}
