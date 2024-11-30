return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },
    "mbbill/undotree",
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }

    },
    {
        "echasnovski/mini.surround",
        opts = {
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",
            },
        },
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
