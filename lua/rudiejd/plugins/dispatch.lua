return {
  {
    "tpope/vim-dispatch"
  },
  {
    "datamadsen/vim-compiler-plugin-for-dotnet",
    config = function ()
      vim.g.dotnet_compiler_errors_only = 1
    end
  }
}
