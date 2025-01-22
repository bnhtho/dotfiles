return{
                "yioneko/nvim-cmp",
                branch = "perf",
                event = {"BufReadPre", "BufNewFile", "InsertEnter"},
                dependencies = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    {
                        "L3MON4D3/LuaSnip",
                        dependencies = {"rafamadriz/friendly-snippets"}
                    },
                    "saadparwaiz1/cmp_luasnip",
                    "hrsh7th/cmp-nvim-lsp-signature-help",
                    "onsails/lspkind.nvim"
                },
                config = function()
                    local kind_icons = {
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = ""
                    }
                    --
                    local cmp = require("cmp")
                    local cmplsp = require("cmp_nvim_lsp")
                    local luasnip = require("luasnip")
                    require("luasnip.loaders.from_vscode").lazy_load()
                    cmplsp.setup()
                    cmp.setup(
                        {
                            preselect = false,
                            completion = {
                                completeopt = "menu,menuone,preview,noselect"
                            },
                            snippet = {
                                expand = function(args)
                                    require("luasnip").lsp_expand(args.body) -- For luasnip users
                                end
                            },
                            -- ╔═══════════════════════╗
                            -- ║    Sources Setup      ║
                            -- ╚═══════════════════════╝
                            matching = {
                                disallow_fuzzy_matching = true,
                                disallow_fullfuzzy_matching = true,
                                disallow_partial_fuzzy_matching = true,
                                disallow_partial_matching = false,
                                disallow_prefix_unmatching = true
                            },
                            sources = {
                                {name = "luasnip"},
                                {name = "nvim_lsp"},
                                {name = "path"},
                                {name = "nvim_lua"},
                                {name = "buffer"},
                                {name = "nvim_lsp_signature_help"}
                            },
                            --
                            formatting = {
                                fields = {"abbr", "kind", "menu"},
                                format = function(entry, vim_item)
                                    local kind = vim_item.kind
                                    vim_item.kind = " " .. (kind_icons[kind] or "?") .. ""
                                    local source = entry.source.name
                                    return vim_item
                                end
                            },
                            performance = {
                                max_view_entries = 20
                            },
                            -- Keybind
                            mapping = {
                                -- manually trigger completion menu
                                -- ["<Cr>"] = cmp.mapping.complete(),
                                ["<Down>"] = cmp.mapping.select_next_item(),
                                ["<Up>"] = cmp.mapping.select_prev_item(),
                                ["<CR>"] = cmp.mapping.confirm({select = true}),
                                ["<C-y>"] = cmp.mapping.scroll_docs(-1),
                                ["<C-e>"] = cmp.mapping.scroll_docs(1),
                                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                -- close completion menu
                                ["<C-c>"] = cmp.mapping.close(),
                                -- Super-tab mapping
                                ["<Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            -- regular selection
                                            cmp.confirm(
                                                {
                                                    behavior = cmp.ConfirmBehavior.Insert,
                                                    select = true
                                                }
                                            )
                                        elseif luasnip.expand_or_locally_jumpable() then
                                            -- trigger snippet
                                            luasnip.expand_or_jump()
                                        elseif has_words_before() then
                                            -- if non-whitespace before cursor, trigger completion menu
                                            cmp.complete()
                                        else
                                            fallback()
                                        end
                                    end,
                                    {"i", "s"}
                                ),
                                ["<S-Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            -- consume word after cursor (<Tab> behaviour is to prepend to it)
                                            cmp.confirm(
                                                {
                                                    select = true,
                                                    behavior = cmp.ConfirmBehavior.Replace
                                                }
                                            )
                                        elseif luasnip.jumpable(-1) then
                                            luasnip.jump(-1)
                                        else
                                            fallback()
                                        end
                                    end
                                )
                            }
                        }
                    )
                end
            }