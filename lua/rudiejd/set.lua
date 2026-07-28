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
vim.opt.signcolumn = 'yes'

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- time to wait for a mapped sequence to complete
vim.o.timeoutlen = 100
vim.o.ttimeoutlen = 100

-- fold settings
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- don't show warnings, project files in dotnet builds https://github.com/neovim/neovim/blob/2c6b6358722b2df9160c3739b0cea07e8779513f/runtime/compiler/dotnet.vim#L17
vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false

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

vim.filetype.add {
  pattern = {
    ['.*csproj'] = 'xml.csproj',
  },
}
--
-- todo - figure out how to make this lua
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'Tiltfile,tiltfile',
  desc = 'Set filetype to tiltfile',
  group = vim.api.nvim_create_augroup('ftdetect_tiltfile', {}),
  callback = function()
    vim.cmd 'set filetype=tiltfile'
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'docker-compose*.yml',
  desc = 'Set filetype to docker compose',
  group = vim.api.nvim_create_augroup('ftdetect_dockercompose', {}),
  callback = function()
    vim.cmd 'set filetype=yaml.docker-compose'
  end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('nvim_cmdwin_syntax', {}),
  callback = function()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd 'set syntax=vim'
    end
  end,
})

-- vim.api.nvim_create_autocmd('BufWinLeave', {
--   pattern = '*',
--   desc = 'Detach the csharp_ls when the buffer is hidden for better performance',
--   group = vim.api.nvim_create_augroup('csharp_ls_unattach', {}),
--   callback = function(ev)
--     local bufnr = ev.buf
--     for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
--       if client.name == 'csharp_ls' then
--         vim.lsp.buf_detach_client(bufnr, client.id)
--       end
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   pattern = '*',
--   desc = 'Attach the csharp_ls when we enter a buffer, since we kill it when a buffer is hidden',
--   group = vim.api.nvim_create_augroup('csharp_ls_reattach', {}),
--   callback = function(ev)
--     local bufnr = ev.buf
--
--     for _, client in pairs(vim.lsp.get_clients()) do
--       if client.name == 'csharp_ls' then
--         vim.lsp.buf_attach_client(bufnr, client.id)
--       end
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = '*.cs',
--   desc = 'Run dotnet compiler on write',
--   group = vim.api.nvim_create_augroup('run_dotnet_compiler', {}),
--   callback = function(ev)
--     vim.cmd('Dispatch dotnet build --no-restore --nologo -v:q /property:WarningLevel=0')
--   end,
-- })

vim.api.nvim_create_user_command(
  'DiffOrig',
  'vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis',
  {}
)

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

-- transparent background
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

--  completion
-- vim.opt.completeopt = { "menuone", "noinsert", "popup" }
-- vim.o.pumheight = 20
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })
--

-- with ui2, cmd is a floating window. free real estate!
vim.o.cmdheight = 0

local api = vim.api

---@type integer?
local win_id = nil

---@type integer?
local buf_id = nil

---@type { row: integer, col_offset: integer }
local config = {
  row = 2,
  col_offset = 4,
}

---@return nil
local function close_banner()
  if win_id and api.nvim_win_is_valid(win_id) then
    api.nvim_win_close(win_id, true)
  end

  if buf_id and api.nvim_buf_is_valid(buf_id) then
    api.nvim_buf_delete(buf_id, { force = true })
  end

  win_id = nil
  buf_id = nil
end

---@return nil
local function open_banner()
  local reg = vim.fn.reg_recording()

  if reg == '' then
    return
  end

  close_banner()

  local text = string.format(' ● REC @%s ', reg)

  buf_id = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf_id, 0, -1, false, { text })

  local col = vim.o.columns - #text - config.col_offset

  win_id = api.nvim_open_win(buf_id, false, {
    relative = 'editor',
    width = #text,
    height = 1,
    row = config.row,
    col = col,
    style = 'minimal',
    border = 'none',
    focusable = false,
    zindex = 150,
  })

  api.nvim_set_option_value('winhighlight', 'Normal:DiagnosticError', { win = win_id })
end

local group = api.nvim_create_augroup('MacroRecordingBanner', { clear = true })

api.nvim_create_autocmd('RecordingEnter', { group = group, callback = open_banner })
api.nvim_create_autocmd('RecordingLeave', {
  group = group,
  callback = function()
    vim.defer_fn(close_banner, 50)
  end,
})
api.nvim_create_autocmd('VimResized', {
  group = group,
  callback = function()
    if win_id and api.nvim_win_is_valid(win_id) then
      open_banner()
    end
  end,
})
