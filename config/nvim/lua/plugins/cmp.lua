return{
    { -- Do read the installation section in the readme of mini.snippets!
    "echasnovski/mini.snippets",
    dependencies = "rafamadriz/friendly-snippets",
    event = "InsertEnter", -- don't depend on other plugins to load...
    -- :h MiniSnippets-examples:
    opts = function()
      local snippets = require("mini.snippets")
      return { snippets = { 
        snippets.gen_loader.from_lang(),
        snippets.gen_loader.from_file('~/.config/nvim/snippets/global.json'), 
    }}
    end,
  },
    {"yioneko/nvim-cmp",
    branch = "perf",
    event = {"BufReadPre", "BufNewFile", "InsertEnter"},
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "abeldekat/cmp-mini-snippets",
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
        cmplsp.setup()
        cmp.setup(
            {
                preselect = false,
                completion = {
                    completeopt = "menu,menuone,preview,noselect"
                },
                snippet = {
                    expand = function(args) -- mini.snippets expands snippets from lsp...
                      local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                      insert({ body = args.body }) -- Insert at cursor
                    end,
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
                    {
                        name = "mini_snippets",
                        option = {
                          -- completion items are cached using default mini.snippets context:
                          use_items_cache = false -- default: true
                        }
                    },
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
                    ["<Tab>"] = cmp.mapping.confirm({select = true}),
                    ["<C-y>"] = cmp.mapping.scroll_docs(-1),
                    ["<C-e>"] = cmp.mapping.scroll_docs(1),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- close completion menu
                    ["<C-c>"] = cmp.mapping.close(),
                    -- Super-tab mapping
               }
            }
        )
    end
}
}
