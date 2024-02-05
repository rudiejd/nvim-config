return {
  "sourcegraph/sg.nvim",
  dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
  },
  branch = "custom-headers",
  config = function()
      require("sg").setup({
          src_headers = {
              Cookie = os.getenv("SRC_COOKIE")
          }
      })
  end,
}
