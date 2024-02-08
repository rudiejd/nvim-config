return {
  {
    "tpope/vim-dispatch"
  },
  {
    "datamadsen/vim-compiler-plugin-for-dotnet",
    init = function()
      vim.g.dotnet_compiler_errors_only = 1
    end
  }
}
