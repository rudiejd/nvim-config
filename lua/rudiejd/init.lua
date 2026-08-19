vim.lsp.enable 'lua_ls'
vim.lsp.enable 'rust_analyzer'
-- C#
-- vim.lsp.config("csharp_ls", {
--   handlers = {
--     ['textDocument/definition'] = require('csharpls_extended').handler,
--     ['textDocument/implementation'] = require('csharpls_extended').handler,
--     ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
--   },
-- })
vim.lsp.enable 'csharp_ls'
vim.lsp.config('msbuild_project_tools_server', {
  cmd = {
    'dotnet',
    'insert-path-to-host-dll',
  },
  init_options = {
    msbuildProjectToolsServer = {
      logging = {
        level = 'verbose',
      },
    },
  },
})
vim.lsp.enable 'msbuild_project_tools_server'

-- python
vim.lsp.enable 'ty'

-- C++
vim.lsp.enable 'clangd'

vim.lsp.enable 'ocamllsp'

-- JS/TS
-- vim.lsp.enable 'vtsls'
vim.lsp.enable 'svelte'

vim.lsp.enable 'dockerls'
vim.lsp.enable 'docker_compose_language_service'

vim.lsp.enable 'jdtls'

vim.lsp.config('yamlls', {
  settings = {
    schemas = {
      ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '*',
    },
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    single_file_support = true,
    filetypes = { 'yaml', 'yaml.docker-compose' },
  },
})
vim.lsp.enable 'yamlls'

vim.lsp.enable 'helm_ls'

vim.lsp.enable 'tilt_ls'
vim.lsp.enable 'bashls'

vim.lsp.enable 'neocmake'

vim.lsp.enable 'gopls'

vim.lsp.enable 'tailwindcss'

vim.lsp.enable 'terraformls'

vim.lsp.enable 'racket_langserver'

-- elixir
vim.lsp.enable 'expert'

-- LaTeX
vim.lsp.enable 'texlab'

vim.lsp.enable 'copilot'

require 'rudiejd.remap'
require 'rudiejd.set'
require 'rudiejd.aucmd'
require 'rudiejd.lazy'

require('vim._core.ui2').enable {
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
}
