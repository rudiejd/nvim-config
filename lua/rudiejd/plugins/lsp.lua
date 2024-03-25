return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'j-hui/fidget.nvim',                       tag = 'legacy', opts = {} },
      { 'folke/neodev.nvim' },
      { 'Decodetalkers/csharpls-extended-lsp.nvim' },
      { 'Hoffs/omnisharp-extended-lsp.nvim' },
      { 'jmederosalvarado/roslyn.nvim' },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require 'lsp-zero'
      lsp_zero.extend_lspconfig()
      -- formatter config
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps { buffer = bufnr, preserve_mappings = false }
        --- toggle inlay hints
        vim.g.inlay_hints_visible = false
        local function toggle_inlay_hints()
          if vim.g.inlay_hints_visible then
            vim.g.inlay_hints_visible = false
            vim.lsp.inlay_hint.enable(bufnr, false)
          else
            if client.server_capabilities.inlayHintProvider then
              vim.g.inlay_hints_visible = true
              vim.lsp.inlay_hint.enable(bufnr, true)
            else
              print 'no inlay hints available'
            end
          end
        end

        -- inlay hints
        vim.keymap.set('n', '<leader>ih', toggle_inlay_hints)

        -- commenting this out for better performance
        -- lsp_zero.buffer_autoformat()
      end)

      require('neodev').setup {}

      local lspconfig = require 'lspconfig'
      -- (Optional) Configure lua language server for neovim
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(lua_opts)
      require('lspconfig').rust_analyzer.setup {}

      local util = lspconfig.util
      local inherited_interface_position = function(lsp_request)
          -- find the position of the name of the file with 'I' preprended
          local lnum, col = unpack(vim.api.nvim_eval('searchpos("I" . expand("%:t:r"))'))
          local text_document_identifier = vim.lsp.util.make_text_document_params()
          -- uses zero based indices
          local position = { line = lnum - 1, character = col }
          -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#referenceParams
          local params = { position = position, textDocument = text_document_identifier, context = { includeDeclaration = true } }

          vim.lsp.buf_request(0, lsp_request, params)
      end

      lspconfig.csharp_ls.setup {

        root_dir = function(fname)
          local root_patterns = { '*.sln', '*.csproj', 'omnisharp.json', 'function.json' }
          for _, pattern in ipairs(root_patterns) do
            local found = util.root_pattern(pattern)(fname)
            if found then
              return found
            end
          end
        end,
        handlers = {
          ['textDocument/definition'] = require('csharpls_extended').handler,
          ['textDocument/implementation'] = require('csharpls_extended').handler,
          ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
        },
        on_attach = function(client, bufnr)
          vim.keymap.set('n', 'gI', function() inherited_interface_position('textDocument/definition') end)
          vim.keymap.set('n', 'gI', function() inherited_interface_position('textDocument/definition') end)
          client.server_capabilities.semanticTokensProvider = false
        end,
        -- hack to make it attach on BufEnter
        filetypes = {},
      }

      -- python
      lspconfig.pyright.setup {}
      lspconfig.pyright.before_init = function(params, config)
        local Path = require 'plenary.path'
        local venv = Path:new((config.root_dir:gsub('/', Path.path.sep)), '.venv')
        if venv:joinpath('bin'):is_dir() then
          config.settings.python.pythonPath = tostring(venv:joinpath('bin', 'python'))
        else
          config.settings.python.pythonPath = tostring(venv:joinpath('Scripts', 'python.exe'))
        end
      end

      -- -- f# (replaced with ionide)
      -- lspconfig.fsautocomplete.setup({})

      -- C++
      lspconfig.clangd.setup {}

      -- ocaml
      lspconfig.ocamllsp.setup {}

      -- JS/TS
      lspconfig.tsserver.setup {}

      lspconfig.eslint.setup {
        -- not sure if I like this yet
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
        -- this isn't the default, but that one seemed slow
        root_dir = util.find_git_ancestor,
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
          'vue',
          'svelte',
          'astro',
        },
      }

      -- SQLs
      lspconfig.sqlls.setup {}

      -- Docker
      lspconfig.dockerls.setup {}
      lspconfig.docker_compose_language_service.setup {}

      -- Java
      lspconfig.jdtls.setup {}

      -- YAML . I currenlty only use kuberneses YAML, so everything uses that schmea
      lspconfig.yamlls.setup {
        settings = {
          schemas = {
            ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '/*.yaml',
          },
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
          single_file_support = true,
          filetypes = { 'yaml', 'yaml.docker-compose' },
          root_dir = util.find_git_ancestor,
        },
      }

      -- Tilt files (https://tilt.dev)
      lspconfig.tilt_ls.setup {}
      -- bash
      lspconfig.bashls.setup {}

      -- cmake
      lspconfig.neocmake.setup {}

      -- Go
      lspconfig.gopls.setup {}

      -- Tailwind
      lspconfig.tailwindcss.setup { filetypes = {"html"}}
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = "VeryLazy",
    -- CTRL-s for SIGNATURE
    opts = { toggle_key = "<C-s>"},
    config = function(_, opts)
      require 'lsp_signature'.setup(opts)
    end
  }
}
