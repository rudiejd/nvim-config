return {
  "nvim-neorg/neorg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes"
            }
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
