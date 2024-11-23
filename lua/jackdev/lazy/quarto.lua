return {
    {
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        config = function()
            require('jupytext').setup({
                style = "percent",
                output_extension = "auto",
                force_ft = "python",
            })
        end,
        dependencies = {
            "hkupty/iron.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        "hkupty/iron.nvim",
        lazy = false,
        config = function()
            local iron = require("iron.core")

            iron.setup({
                config = {
                    scratch_repl = false,     -- Changed to false
                    close_on_bdelete = false, -- Changed to false
                    repl_definition = {
                        python = {
                            command = { "ipython" },
                            format = require("iron.fts.common").bracketed_paste,
                        },
                    },
                    repl_open_cmd = "vertical botright 80 split",
                },
                keymaps = {
                    visual_send = "<space>sc",
                    send_line = "<space>sl",
                },
            })

            -- Function to check if IPython is already running
            local function ensure_ipython_running()
                local buffers = vim.api.nvim_list_bufs()
                local ipython_running = false
                for _, buf in ipairs(buffers) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                        local name = vim.api.nvim_buf_get_name(buf)
                        if name:match("ipython") then
                            ipython_running = true
                            break
                        end
                    end
                end
                if not ipython_running then
                    vim.cmd("IronRepl")
                end
            end

            -- Function to run cell
            local function run_cell()
                ensure_ipython_running()
                local start_line = vim.fn.search("^# %%", "bnW")
                local end_line = vim.fn.search("^# %%", "nW") - 1
                if end_line < 0 then
                    end_line = vim.fn.line('$')
                end

                if start_line > 0 then
                    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
                    iron.send("python", lines)
                end
            end

            -- Set up keymaps
            local map = vim.keymap.set
            map('n', '<CR>', run_cell, { noremap = true, silent = true, desc = "Run current cell" })
            map('n', '<leader>rr', run_cell, { noremap = true, silent = true, desc = "Run current cell" })

            -- Run current line
            map('n', '<leader>rc', function()
                ensure_ipython_running()
                local line = vim.api.nvim_get_current_line()
                iron.send("python", { line })
            end, { noremap = true, silent = true, desc = "Run current line" })

            -- Run visual selection
            map('v', '<leader>rs', function()
                ensure_ipython_running()
                vim.cmd('normal! "vy"')
                local lines = vim.split(vim.fn.getreg('v'), '\n')
                iron.send("python", lines)
            end, { noremap = true, silent = true, desc = "Run selection" })

            -- REPL management
            map('n', '<leader>ro', function()
                ensure_ipython_running()
            end, { noremap = true, silent = true, desc = "Open REPL" })

            -- Cell navigation
            map('n', ']]', '/^# %%<CR>', { noremap = true, silent = true, desc = "Next cell" })
            map('n', '[[', '?^# %%<CR>', { noremap = true, silent = true, desc = "Previous cell" })

            -- Auto-open REPL for .ipynb files
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = "*.ipynb",
                callback = function()
                    vim.cmd("set filetype=python")
                    vim.defer_fn(function()
                        ensure_ipython_running()
                    end, 100)
                end,
            })
        end,
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")
            notify.setup({
                background_colour = "#000000",
                timeout = 3000,
                max_height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                max_width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
            })
            vim.notify = notify
        end,
    },
}

