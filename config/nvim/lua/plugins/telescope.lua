return {
  "nvim-telescope/telescope.nvim",
  version = false, -- Use the latest version
  dependencies = {
    { "nvim-lua/plenary.nvim" }, -- Required dependency
  },
  config = function()
    local telescope = require("telescope")

    -- Telescope setup
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        layout_config = {
          horizontal = { preview_width = 0.6 },
          vertical = { preview_height = 0.7 },
        },
      },
      extensions = {
        -- Add configurations for extensions here
        fzf = {
          fuzzy = true,                    -- Fuzzy matching
          override_generic_sorter = true, -- Override the generic sorter
          override_file_sorter = true,    -- Override the file sorter
          case_mode = "smart_case",       -- Options: "ignore_case", "respect_case", "smart_case"
        },
      },
    })

    -- Load extensions
  end,
}
