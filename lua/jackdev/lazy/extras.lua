return {
    {
        "eandrju/cellular-automaton.nvim",
        config = function()
            vim.keymap.set("n", "<leader>fml", function()
                -- Get current buffer's filetype
                local current_ft = vim.bo.filetype

                -- List of filetypes to exclude
                local excluded_filetypes = {
                    "fern",
                    "NvimTree",
                    "neo-tree",
                    "TelescopePrompt",
                    "mason",
                    "lazy",
                }

                -- Check if current filetype is in excluded list
                for _, ft in ipairs(excluded_filetypes) do
                    if current_ft == ft then
                        vim.notify("Cellular automaton not available in " .. ft .. " buffer", vim.log.levels.WARN)
                        return
                    end
                end

                -- If we get here, run the animation
                vim.cmd("CellularAutomaton make_it_rain")
            end)
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        }
    },
    "ThePrimeagen/vim-be-good",
    "alec-gibson/nvim-tetris",
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
            rocks = { "magick" },
        },
    },
}
