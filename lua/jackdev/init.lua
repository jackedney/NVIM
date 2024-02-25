require("jackdev.remap")
require("jackdev.set")
require("jackdev.lazy_init")

local augroup = vim.api.nvim_create_augroup
local JackDevGroup = augroup('JackDevGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40
        })
    end
})

autocmd('BufWritePost', {
    group = JackDevGroup,
    pattern = '*',
    command = [[%s/\\+$//e]],
})

autocmd('LspAttach', {
    group = JackDevGroup,
    callback = function(e)
        vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})

local fern_custom = augroup('FernCustom', {})

autocmd('FileType', {
    group = fern_custom,
    pattern = 'fern',
    callback = function()
        vim.keymap.set("n", "<Plug>(fern-action-open)", "<Plug>(fern-action-open:select)")
        vim.keymap.set("n", "<Leader>:", "<Plug>(fern-action-preview:auto:toggle)")
        vim.keymap.set("n", "<Leader>N", "<Plug>(fern-action-new-dir)")
    end
})
