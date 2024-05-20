return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gl', ':.GBrowse!<CR>', { desc = '[G]it [B]rowse' })
    end,
  },
  { 'tpope/vim-rhubarb' },
  {
    'tommcdo/vim-fubitive',
    config = function()
      vim.g.fubitive_domain_pattern = 'bitbucket.build.dkinternal.com'
    end,
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          'n',
          '<leader>gp',
          require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[G]it [P]review' }
        )
        vim.keymap.set(
          'n',
          '<leader>gr',
          require('gitsigns').reset_hunk,
          { buffer = bufnr, desc = '[G]it [R]eset Hunk' }
        )
        vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis, { buffer = bufnr, desc = '[G]it [D]iff' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },
  {
    'sindrets/diffview.nvim',
    config = function ()
      require('diffview').setup()
    end
  }
}
