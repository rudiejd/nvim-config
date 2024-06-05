local util = require 'rudiejd.util'
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'mfussenegger/nvim-dap-python' },
    config = function()
      local dap = require 'dap'

      dap.adapters.netcoredbg = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }

      dap.defaults.fallback.external_terminal = {
        command = 'alacritty.exe',
        args = { '-e', 'wsl' },
      }

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = 'OpenDebugAD7',
      }
      dap.configurations.c = {
        {
          name = 'Neovim',
          type = 'cppdbg',
          request = 'launch',
          program = '/home/jd/git/neovim/build/bin/nvim',
          cwd = '${workspaceFolder}',
          externalConsole = true,
        },
        {
          name = 'Launch file',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
        },
      }

      dap.configurations.cs = {
        {
          type = 'netcoredbg',
          name = 'Endpoint DLLs',
          request = 'launch',
          program = function()
            print(vim.inspect(util.find_endpoint_dlls()))
            return util.find_endpoint_dlls()[1]
          end,
        },
        {
          type = 'netcoredbg',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
        {
          type = 'netcoredbg',
          name = 'Attach - netcoredbg',
          request = 'attach',
          processId = require('dap.utils').pick_process
        },
        {
          type = 'netcoredbg',
          name = 'CLI - netcoredbg',
          request = 'launch',
          processId = require('dap.utils').pick_process,
          program = function()
            local program = vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            local arguments = vim.fn.input('Arguments: ')

            return program .. ' ' .. arguments
          end,
        },
      }

      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<leader>ds', dap.step_over, { desc = '[D]ebug [S]tep' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug [I]nto' })
      vim.keymap.set('n', '<leader>do', dap.step_out, { desc = '[D]ebug [O]ver' })
      vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
      vim.keymap.set('n', '<Leader>dr', dap.toggle_breakpoint, { desc = '[D]ebug [R]EPL' })
      vim.keymap.set('n', '<Leader>dl', dap.run_last, { desc = '[D]ebug [L]ast' })
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {'nvim-neotest/nvim-nio'},
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
          -- Example:
          -- stacks = {
          --   open = "<CR>",
          --   expand = "o",
          -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has 'nvim-0.7' == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = 'scopes', size = 0.25 },
              'breakpoints',
              'stacks',
              'watches',
            },
            size = 40, -- 40 columns
            position = 'left',
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = 'repl',
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '↻',
            terminate = '□',
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = 'single', -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'red', linehl = '', numhl = '' })
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {'mfussenegger/nvim-dap' },
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  }
}
