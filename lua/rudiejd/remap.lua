vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.keymap.set('i', '<C-S>', function()
  vim.lsp.buf.signature_help()
end, { buffer = true })

-- yank to windows clipboard
vim.opt.clipboard = 'unnamedplus'
if vim.fn.has 'wsl' == 1 then
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('Yank', { clear = true }),
    callback = function()
      vim.fn.system('clip.exe', vim.fn.getreg '"')
    end,
  })
end

-- toggle line break and word wrap
-- (l)ine (b)reak
vim.keymap.set('n', '<leader>lb', function()
  if vim.o.linebreak then
    vim.o.linebreak = false
    vim.o.wrap = false
  else
    vim.o.linebreak = true
    vim.o.wrap = true
  end
end)

-- build a dotnet project
vim.keymap.set('n', '<leader>bd', ':Dispatch dotnet build /property:WarningLevel=0<CR>', { desc = '[B]uild [D]otnet' });

-- Center the window (zz) when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center the window when scrolling down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center the window when scrolling down' })

vim.keymap.set('n', '<leader>x', vim.diagnostic.setqflist, { desc = 'E[x]ception - open diagnostics in qfist' })
-- This pneumonic is really bad, I'm just used to the built-in bind that got removed
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = '[G]o [L]ist - open diagnostic list. ' })

-- Enable/disable virtual text
vim.keymap.set('n', ']oy', function() vim.diagnostic.config { virtual_text = false } end,
  { desc = 'Disable virtual text for LSP diagnostics' })
vim.keymap.set('n', '[oy', function() vim.diagnostic.config { virtual_text = true } end,
  { desc = 'Enable virtual text for LSP diagnostics' })

-- Enable / disable sign column
vim.keymap.set('n', ']oz', function() vim.opt.signcolumn = 'no' end,
  { desc = 'Disable signcolumn' })
vim.keymap.set('n', '[oz', function() vim.opt.signcolumn = 'yes' end,
  { desc = 'Enable signcolumn' })
