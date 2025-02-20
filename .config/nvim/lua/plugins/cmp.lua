return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  opts = {
    keymap = {
      preset = 'default',
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'accept', 'fallback' },
      ['<C-e>'] = {},
      ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
      ['<C-n>'] = { 
        function(cmp)
          if some_condition then return end
          return true
        end,
        'select_next'
      },
    },
    
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 5,treesitter_highlighting = false },
      ghost_text = { enabled = true },
      trigger = { show_on_trigger_character = true },
      menu = { draw = { treesitter = {'lsp'} } },
      -- menu : 
      menu = {
        auto_show = true,
      }
    },
    
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { "sources.default" },
}
