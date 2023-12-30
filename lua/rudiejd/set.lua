vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- gutter space for lsp info on top left
vim.opt.signcolumn = "yes"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- time to wait for a mapped sequence to complete
vim.o.timeoutlen = 100
vim.o.ttimeoutlen = 100


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

--
-- vim.filetype.add({
--   extension = {
--     foo = 'fooscript',
--     bar = function(path, bufnr)
--       if some_condition() then
--         return 'barscript', function(bufnr)
--           -- Set a buffer variable
--           vim.b[bufnr].barscript_version = 2
--         end
--       end
--       return 'bar'
--     end,
--   },
--   filename = {
--     ['.foorc'] = 'toml',
--     ['/etc/foo/config'] = 'toml',
--   },
--   pattern = {
--     ['.*&zwj;/etc/foo/.*'] = 'fooscript',
--     -- Using an optional priority
--     ['.*&zwj;/etc/foo/.*%.conf'] = { 'dosini', { priority = 10 } },
--     -- A pattern containing an environment variable
--     ['${XDG_CONFIG_HOME}/foo/git'] = 'git',
--     ['README.(%a+)$'] = function(path, bufnr, ext)
--       if ext == 'md' then
--         return 'markdown'
--       elseif ext == 'rst' then
--         return 'rst'
--       end
--     end,
--   },
-- })
--
-- todo - figure out how to make this lua
vim.cmd("autocmd BufRead Tiltfile setf=tiltfile")


vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('nvim_cmdwin_syntax', {}),
  callback = function ()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd('set syntax=vim')
    end
  end
})
