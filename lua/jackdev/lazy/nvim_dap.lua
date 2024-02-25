function CreateKeyBindings()
    vim.api.nvim_set_keymap('n', '<leader>bp', ':lua require("dap").toggle_breakpoint()<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").continue()<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>di', ':lua require("dap").step_into()<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>do', ':lua require("dap").step_over()<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>db', ':lua require("dap").repl.open()<CR>', { silent = true })
end

return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require('dap')
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'attach',
                    name = 'Debugpy',
                    justMyCode = false,
                    host = 'localhost',
                    port = 5678,
                }
            }
            require('dap-python').setup(vim.fn.exepath('python'))
            CreateKeyBindings()
        end,
        dependencies = {
            "mfussenegger/nvim-dap-python",
        }
    }
}
