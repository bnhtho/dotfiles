return {
	"nvim-treesitter/nvim-treesitter",
	build = ':TSUpdate',
	config = function()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
	-- Bypass default setup here
	ensure_installed = { "cpp", "lua", "vim", "vimdoc", "query", "python", "nix", "javascript", "html","bash" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
	})
	end
	-- Install tree sitter
}
