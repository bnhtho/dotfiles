return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = "doom",
      config = {
        header = {
          
          "                                           ",
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "                                                       ",
          "                                                       ",
        },
        center = {
          {
            desc = 'Old files',
            desc_hl = 'group',
            key_hl = 'group',
            key_format = ' [%s]', -- `%s` will be substituted with value of `key`
            action = 'Telescope oldfiles',
          },
          {
            desc = 'Find files',
            desc_hl = 'group',
            key_hl = 'group',
            key_format = ' [%s]', -- `%s` will be substituted with value of `key`
            action = 'Telescope find_files',
          },
          {
            desc = 'Search String',
            desc_hl = 'group',
            key_hl = 'group',
            key_format = ' [%s]', -- `%s` will be substituted with value of `key`
            action = 'Telescope live_grep',
          },
          {
            desc = 'Quit',
            desc_hl = 'group',
            key_hl = 'group',
            key_format = ' [%s]', -- `%s` will be substituted with value of `key`
            action = 'quit',
          }
        },
        footer = { "Current Directory: " .. vim.fn.getcwd() },
        vertical_center = true, -- Center the Dashboard on thea vertical (from top to bottom)
      }
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
