return {
  'nvim-telescope/telescope.nvim',
  -- dev = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'benfowler/telescope-luasnip.nvim',
  },
  config = function()
    require('telescope').load_extension 'luasnip'
    require('telescope').load_extension 'projects'

    local builtin = require 'telescope.builtin'
    local telescope = require 'telescope'

    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sp', builtin.git_files, { desc = '[S]earch [P]roject' })
    vim.keymap.set('n', '<leader>st', builtin.live_grep, { desc = '[S]earch [T]ext' })
    vim.keymap.set('n', '<Leader>sr', builtin.lsp_references, { desc = '[S]earch [R]eferences' })
    vim.keymap.set('n', '<Leader>sR', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sx', builtin.diagnostics, { desc = '[S]earch E[x]ceptions' })
    vim.keymap.set('n', '<leader>ss', telescope.extensions.luasnip.luasnip, { desc = '[S]earch [S]nippets' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sa', function()
      builtin.builtin { include_extensions = true }
    end, { desc = '[S]earch [A]ll (pickers)' })

    local function send_current_buffer_to_qflist()
      local actions = require 'telescope.actions'
      local current_bufnr = vim.api.nvim_get_current_buf()
      actions.send_to_qflist { prompt_bufnr = current_bufnr }
    end

    vim.keymap.set('n', '<C-q>', send_current_buffer_to_qflist, {})

    telescope.setup {
      defaults = {
        preview = {
          treesitter = false,
        },
        layout_strategy = "vertical"
      },
    }
  end,
}
