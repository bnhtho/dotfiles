return {
	{
'echasnovski/mini.icons', version = false,
	config = function()
	require("mini.icons").setup()
	end
	},
	-- {
{
	'echasnovski/mini.pairs', version = false,
	config = function()
	require("mini.pairs").setup()
	end
},
{
	"echasnovski/mini.indentscope",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mini.indentscope").setup({})
	end
},
{
	'echasnovski/mini.tabline', version = false,
	config = function()
	require("mini.tabline").setup()
	end
}
	-- },
	
}
