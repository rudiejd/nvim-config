return {
  "kndndrj/nvim-dbee",
  -- dev = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup {
      sources = {
        require("dbee.sources").MemorySource:new({
          {
          },
          -- ...
        })
      } }
  end,
}
