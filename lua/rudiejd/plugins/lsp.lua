return {
  {
   'VonHeikemen/lsp-zero.nvim',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  -- {
  --   'Decodetalkers/csharpls-extended-lsp.nvim',
  -- },
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
      -- { 'Hoffs/omnisharp-extended-lsp.nvim' },
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
        }
      }

      -- lspconfig.omnisharp.setup {
      --   cmd = {"omnisharp"},
      --   handlers = {
      --     ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
      --     ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
      --     ["textDocument/references"] = require('omnisharp_extended').references_handler,
      --     ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
      --   },
      -- }
      --
      --
      -- require('roslyn').setup({
      --   on_attach = function() end,
      --   capabilities = vim.lsp.protocol.make_client_capabilities()
      -- })
      --
      lspconfig.msbuild_project_tools_server.setup {
        cmd = {"dotnet", "/home/hermeslover69/github/msbuild-project-tools-server/out/language-server/MSBuildProjectTools.LanguageServer.Host.dll"},
        init_options = {
          msbuildProjectToolsServer = {
            logging = {
              level = "verbose",
            }
          }
        }
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
      lspconfig.vtsls.setup {}

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

      -- Docker
      lspconfig.dockerls.setup {}
      lspconfig.docker_compose_language_service.setup {}

      -- Java
      lspconfig.jdtls.setup {}

      -- -- YAML . I currenlty only use kuberneses YAML, so everything uses that schmea
      lspconfig.yamlls.setup {
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
      }


      -- helm files
      lspconfig.helm_ls.setup {}


      -- Tilt files (https://tilt.dev)
      lspconfig.tilt_ls.setup {}
      -- bash
      lspconfig.bashls.setup {}

      -- cmake
      lspconfig.neocmake.setup {}

      -- Go
      lspconfig.gopls.setup {}

      -- Tailwind
      lspconfig.tailwindcss.setup { filetypes = { "html" } }
      -- lspconfig.lexical.setup {
      --   cmd = { vim.fn.expand("~/git/lexical/_build/dev/package/lexical/bin/start_lexical.sh") },
      --   root_dir = function(fname)
      --     return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
      --   end,
      --   filetypes = { "elixir", "eelixir", "heex" },
      --   -- optional settings
      --   settings = {}
      -- }
      lspconfig.elixirls.setup{ cmd = {"elixir-ls"} }
      -- lspconfig.nextls.setup { cmd = {"nextls"} }

      -- terraform LSP
      lspconfig.terraformls.setup{}
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = "VeryLazy",
    -- CTRL-s for SIGNATURE
    opts = { toggle_key = "<C-s>" },
    config = function(_, opts)
      require 'lsp_signature'.setup(opts)
    end
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
  }
}
