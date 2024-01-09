return {
	"ahmedkhalf/project.nvim",
	config = function()
		local opts = {
			detection_methods = { "pattern" },
			patterns = { ".git" },
		}
		require("project_nvim").setup(opts)
	end,
}
