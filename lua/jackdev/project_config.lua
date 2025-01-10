local M = {}

function M.setup()
    -- Load project-specific configuration
    local function load_project_config()
        local project_config = vim.fn.getcwd() .. '/.nvim/init.lua'
        if vim.fn.filereadable(project_config) == 1 then
            dofile(project_config)
        end
    end

    -- Add autocommand for project config
    vim.api.nvim_create_autocmd("VimEnter", { callback = load_project_config })

    -- TypeScript formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.ts,*.tsx",
        callback = function()
            vim.lsp.buf.format()
            vim.cmd("TypescriptOrganizeImports")
        end,
    })
end

return M
