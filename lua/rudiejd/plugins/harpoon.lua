return {
  'theprimeagen/harpoon',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    vim.keymap.set('n', '<leader>a', mark.add_file)
    vim.keymap.set('n', '<leader>a', mark.add_file)
    vim.keymap.set('n', '<C-e>', function()
      ui.toggle_quick_menu()
      vim.cmd.norm("$ze")
    end, {desc = "Toggle Harpoon Menu"})

    vim.keymap.set('n', '<leader>1', function()
      ui.nav_file(1)
    end, { desc = '[1]st harpoon' })
    vim.keymap.set('n', '<leader>2', function()
      ui.nav_file(2)
    end, { desc = '[2]nd harpoon' })
    vim.keymap.set('n', '<leader>3', function()
      ui.nav_file(3)
    end, { desc = '[3]rd harpoon' })
    vim.keymap.set('n', '<leader>4', function()
      ui.nav_file(4)
    end, { desc = '[4]th harpoon' })
  end,
}
