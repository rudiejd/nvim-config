vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
-- C#
-- vim.lsp.config("csharp_ls", {
--   handlers = {
--     ['textDocument/definition'] = require('csharpls_extended').handler,
--     ['textDocument/implementation'] = require('csharpls_extended').handler,
--     ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
--   },
-- })
vim.lsp.enable('csharp_ls')
vim.lsp.config("msbuild_project_tools_server", {
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
  }
})
vim.lsp.enable('msbuild_project_tools_server')

-- python
vim.lsp.enable('ty')

-- C++
vim.lsp.enable('clangd')

vim.lsp.enable('ocamllsp')

-- JS/TS
vim.lsp.enable('vtsls')
vim.lsp.enable('svelte')

vim.lsp.enable('dockerls')
vim.lsp.enable('docker_compose_language_service')

vim.lsp.enable('jdtls')

vim.lsp.config('yamlls', {
  settings = {
    schemas = {
      ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] =
      '*',
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
vim.lsp.enable('yamlls')

vim.lsp.enable('helm_ls')

vim.lsp.enable('tilt_ls')
vim.lsp.enable('bashls')

vim.lsp.enable('neocmake')

vim.lsp.enable('gopls')

vim.lsp.enable('tailwindcss')

vim.lsp.enable('terraformls')

vim.lsp.enable('racket_langserver')

-- elixir
vim.lsp.enable('expert')

require 'rudiejd.remap'
require 'rudiejd.set'
require 'rudiejd.lazy'
