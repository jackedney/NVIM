return {
    {
        "Everblush/nvim",
        name = "everblush",
        config = function()
            require('everblush').setup({
                compile = false,  -- enable compiling the colorscheme
                undercurl = true, -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},

                transparent = false,         -- do not set background color
                dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
                terminalColors = true,       -- define vim.g.terminal_color_{0,17}

                overrides = function(colors) -- add/modify highlights
                    return {}
                end,
            })
        end
    },
    {
        "Everblush/nvim",
        name = "everblush",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme everblush]])
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
                    'markdown',
                    'markdown_inline',
                    'tsx',
                    'html',
                    'css',
                    'vim',
                    'query'
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = false },
            })
        end
    },
    'nvim-treesitter/nvim-treesitter-context',
}
