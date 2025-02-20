return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- set to 'none' to disable the 'default' preset
      preset = 'default',

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'accept','fallback' },
      -- disable a keymap from the preset
      ['<C-e>'] = {},
      
      -- show with a list of providers
      ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },

      -- control whether the next command will be run when using a function
      ['<C-n>'] = { 
        function(cmp)
          if some_condition then return end -- runs the next command
          return true -- doesn't run the next command
        end,
        'select_next'
      },

      -- optionally, separate cmdline and terminal keymaps
      
    },
    
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    completion = {
      -- Show completion document and delay with 0.005s
      documentation = { auto_show = true, auto_show_delay_ms = 5 },
      -- Ghost text
      ghost_text = { enabled = false },
    },
    
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { "sources.default" },
}
