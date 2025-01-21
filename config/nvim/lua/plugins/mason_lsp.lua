return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
        ensure_installed = {
            "lua_ls",
            "html",       -- Correct server name for HTML
            "emmet_ls",   -- Correct server name for Emmet
            "clangd",
            "pyright",
            "marksman",
            "sqlls",
            "jdtls"
        }
    }
}
