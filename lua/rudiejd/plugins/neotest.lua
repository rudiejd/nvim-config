return {
  {
    'nvim-neotest/neotest',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'Issafalcon/neotest-dotnet',
      'haydenmeade/neotest-jest',
      'antoinemadec/FixCursorHold.nvim',
      'jfpedroza/neotest-elixir'
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        log_level = 1, -- For verbose logs
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
          },
          require('neotest-plenary').setup {},
          require 'neotest-dotnet' {
            discovery_root = 'solution',
            dotnet_additional_args = {
              '--no-restore',
              '--nologo',
            }
          },
          require 'neotest-jest' {
            jestCommand = 'npm test -- --runInBand --no-cache --watchAll=false',
            env = { CI = 'true' },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
          require 'neotest-elixir'
        },
        icons = {
          expanded = '',
          child_prefix = '',
          child_indent = '',
          final_child_prefix = '',
          non_collapsible = '',
          collapsed = '',

          passed = '',
          running = '',
          failed = '',
          unknown = '',
        },
        summary = {
          enabled = true,
          animated = true,
          expand_errors = true,
          follow = true
        }
      }
      vim.keymap.set('n', '<leader>tr', function()
        neotest.run.run()
      end, { desc = '[T]est [R]un' })
      vim.keymap.set('n', '<leader>tw', function()
        neotest.watch.toggle()
      end, { desc = '[T]est [W]atch' })
      vim.keymap.set('n', '<leader>ta', function()
        neotest.run.run(vim.fn.getcwd())
        neotest.summary.open()
      end, { desc = '[T]est [A]ll' })
      vim.keymap.set('n', '<leader>tl', function()
        neotest.run.run_last()
      end, { desc = '[T]est [L]ast' })
      vim.keymap.set('n', '<leader>td', function()
        neotest.run.run { strategy = 'dap' }
      end, { desc = '[T]est [D]ebug' })
      vim.keymap.set('n', '<leader>ts', function()
        neotest.summary.open()
      end, { desc = '[T]est [S]ummary' })
      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open()
      end, { desc = '[T]est [O]utput' })
      vim.keymap.set('n', '<leader>tp', function()
        neotest.output_panel.open()
      end, { desc = '[T]est [P]anel' })
    end,
  },
}
