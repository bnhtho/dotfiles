local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Keymap when LSP attached
local keymap_lsp_attach = function(_, bufnr)
    local opts = {buffer = bufnr}
    local keymap = vim.keymap.set
    -- keymap("n", "F", MiniExtra.pickers.lsp({ scope = 'references' }), opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
end
local servers = {"pyright", "clangd", "marksman", "lua_ls", "sqlls", "ts_ls", "jdtls", "emmet_language_server"}
for _, server in ipairs(servers) do
    lspconfig[server].setup {
        capabilities = capabilities,
        on_attach = keymap_lsp_attach
    }
end
-- Disable Virtual Text
vim.diagnostic.config(
    {
        virtual_text = false,
	-- Add sign of LSP
	signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
    }
)
