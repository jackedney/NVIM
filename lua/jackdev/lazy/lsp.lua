return {
    {
        -- for lsp features in code cells / embedded code
        'jmbuhr/otter.nvim',
        dev = false,
        dependencies = {
            {
                'neovim/nvim-lspconfig',
                'nvim-treesitter/nvim-treesitter',
                'hrsh7th/nvim-cmp',
            },
        },
        opts = {
            buffers = {
                set_filetype = true,
                write_to_disk = false,
            },
            handle_leading_whitespace = true,
        },
    },
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
            "jmbuhr/otter.nvim",
        },

        opts = function(_, opts)
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")


            opts.mapping = opts.mapping or {}
            opts.mapping["<leader><Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" })

            opts.mapping["<leader><S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" })

            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            'jmbuhr/otter.nvim',
        },
        config = function()
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())
            require 'lspconfig'.mojo.setup {}
            require("fidget").setup()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "ruff_lsp",
                    "pyright",
                    "dockerls",
                    "kotlin_language_server",
                    "taplo",
                    "yamlls",
                    "tsserver",
                    "biome",
                    "marksman",
                    "jqls",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig["lua_ls"].setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" }
                                    }
                                }
                            }
                        }
                    end,
                    ["ruff_lsp"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig["ruff_lsp"].setup {
                            capabilities = capabilities,
                            on_attach = function(client, _)
                                client.server_capabilities.hoverProvider = false
                            end,
                            init_options = {
                                args = {},
                            }
                        }
                    end,
                    ["pyright"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig["pyright"].setup {
                            capabilities = (function()
                                capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
                                return capabilities
                            end)(),
                            settings = {
                                python = {
                                    analysis = {
                                        useLibraryCodeForTypes = true,
                                        diagnosticSeverityOverrides = {
                                            reportUnusedVariable = "warning",
                                        },
                                        typeCheckingMode = "basic",
                                    }
                                }
                            }
                        }
                    end,
                    ["tsserver"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig["tsserver"].setup {
                        }
                    end,
                    ["biome"] = function()
                        local lspconfig = require("lspconfig")

                        lspconfig["biome"].setup {
                        }
                    end,
                    ["marksman"] = function()
                        local lspconfig = require("lspconfig")

                        lspconfig["marksman"].setup {
                            settings = {
                                filetypes = {
                                    "markdown",
                                    "quarto",
                                },
                                root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml", "_quarto.yml"),
                            }
                        }
                    end,
                    ["jqls"] = function()
                        local lspconfig = require("lspconfig")

                        lspconfig["jqls"].setup {
                        }
                    end,
                }
            })

            local cmp = require("cmp")
            local luasnip = require 'luasnip'
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                },
                sources = {
                    { name = 'otter' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmdline' },
                },
            })

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                }
            })
            luasnip.filetype_extend("quarto", { "markdown" })
        end,
    },
    "github/copilot.vim",
    'gptlang/CopilotChat.nvim',
}
