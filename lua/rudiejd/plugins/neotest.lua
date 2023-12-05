return {
    {
        "nvim-neotest/neotest",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "haydenmeade/neotest-jest",
            "antoinemadec/FixCursorHold.nvim",
        },
        config = function()
        end,
    },
    {
        "Issafalcon/neotest-dotnet",
        dependencies = {
            "nvim-neotest/neotest",
        },
        config = function ()
            local neotest = require("neotest")
            neotest.setup({
                log_level = 1, -- For verbose logs
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                    require("neotest-plenary").setup({}),
                    require("neotest-dotnet")({
                        discovery_root = "solution",
                    }),
                    require("neotest-jest")({
                        jestCommand = "npm test -- --runInBand --no-cache --watchAll=false",
                        env = { CI = "true" },
                        cwd = function(path) return vim.fn.getcwd() end,
                    }),
                },
                icons = {
                    expanded = "",
                    child_prefix = "",
                    child_indent = "",
                    final_child_prefix = "",
                    non_collapsible = "",
                    collapsed = "",
                    passed = "",
                    running = "",
                    failed = "",
                    unknown = "",
                    skipped = "",
                },
            })
            vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end)
            vim.keymap.set("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end)
            vim.keymap.set("n", "<leader>ts", function() neotest.summary.open() end)
            vim.keymap.set("n", "<leader>to", function() neotest.output.open() end)
            vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.open() end)
        end
    }
}
