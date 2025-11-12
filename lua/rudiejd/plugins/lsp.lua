return {
{
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'j-hui/fidget.nvim',                       tag = 'legacy', opts = {} },
      { 'folke/neodev.nvim' },
      { 'Decodetalkers/csharpls-extended-lsp.nvim' }
    }
    ,
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require 'lsp-zero'
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

      -- (Optional) Configure lua language server for neovim
      -- local lua_opts = lsp_zero.nvim_lua_ls()

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" } }
          }
        }
      })
      vim.lsp.enable('lua_ls')

      vim.lsp.enable('rust_analyzer')

      vim.lsp.config("csharp_ls", {
        handlers = {
          ['textDocument/definition'] = require('csharpls_extended').handler,
          ['textDocument/implementation'] = require('csharpls_extended').handler,
          ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
        },
      })

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
      vim.lsp.enable('zuban')

      -- C++
      vim.lsp.enable('clangd')

      -- ocaml
      vim.lsp.enable('ocamllsp')

      -- JS/TS
      vim.lsp.enable('vtsls')

      vim.lsp.enable('svelte')

      -- Docker
      vim.lsp.enable('dockerls')
      vim.lsp.enable('docker_compose_language_service')

      -- Java
      vim.lsp.enable('jdtls')

      -- -- YAML . I currenlty only use kuberneses YAML, so everything uses that schmea
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

      -- helm files
      vim.lsp.enable('helm_ls')

      -- Tilt files (https://tilt.dev)
      vim.lsp.enable('tilt_ls')
      -- bash
      vim.lsp.enable('bashls')

      -- cmake
      vim.lsp.enable('neocmake')

      -- Go
      vim.lsp.enable('gopls')

      -- Tailwind
      vim.lsp.enable('tailwindcss')

      -- lspconfig.lexical.setup {
      --   cmd = { vim.fn.expand("~/git/lexical/_build/dev/package/lexical/bin/start_lexical.sh") },
      --   root_dir = function(fname)
      --     return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
      --   end,
      --   filetypes = { "elixir", "eelixir", "heex" },
      --   -- optional settings
      --   settings = {}
      -- }
      -- lspconfig.elixirls.setup { cmd = { 'elixir-ls' } }
      -- lspconfig.nextls.setup { cmd = { 'nextls', '--stdio' } }

      -- terraform LSP
      vim.lsp.enable('terraformls')

      -- racket
      vim.lsp.enable('racket_langserver')
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    -- CTRL-s for SIGNATURE
    opts = { toggle_key = '<C-s>' },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  }
}
