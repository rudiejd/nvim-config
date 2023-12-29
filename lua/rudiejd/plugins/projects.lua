return {
    "ahmedkhalf/project.nvim",
    opts = {
        detection_methods = {"pattern"},
        patterns = { ".git" }
    },
    config =function ()
        require('project_nvim').setup({})
    end
}
