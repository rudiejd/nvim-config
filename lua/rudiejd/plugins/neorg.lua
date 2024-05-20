return {
  "nvim-neorg/neorg",
  dependencies = { 'vhyrro/luarocks.nvim' },
  lazy = false,
  version = '*',
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes"
            },
            default_workspace = "notes"
          }
        },
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp"
          }
        },
      }
    })
  end
}
