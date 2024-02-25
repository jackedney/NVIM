return {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebards = "dark",
                    floats = "dark",
                },
            })
        end
    },
    {
        'bluz71/vim-nightfly-colors',
        lazy = false,
        priority = 1000,
        name = 'nightfly',
        config = function()
            vim.cmd([[colorscheme nightfly]])
            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                ensure_installed = {
                    'bash',
                    'json',
                    'lua',
                    'python',
                    'rust',
                    'toml',
                    'yaml',
                    'dart',
                    'typescript',
                    'tsx',
                    'html',
                    'css'
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = false },
            })
        end
    },
    'nvim-treesitter/nvim-treesitter-context',
}
