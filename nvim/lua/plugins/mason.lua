return {
                "williamboman/mason.nvim",
                dependencies = {
                    -- "hrsh7th/cmp-nvim-lsp",
                    "WhoIsSethDaniel/mason-tool-installer.nvim"
                },
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗"
                        }
                    }
                }
}         
