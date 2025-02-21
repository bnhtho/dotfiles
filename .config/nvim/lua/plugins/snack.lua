return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
        bigfile     = { enabled = true },
        dashboard   = { enabled = false },
        explorer    = { enabled = true },
        indent      = { enabled = false },
        input       = { enabled = false },
        picker      = { enabled = true },
        notifier    = { enabled = false },
        quickfile   = { enabled = false },
        scope       = { enabled = false },
        scroll      = { enabled = false },
        statuscolumn = { enabled = false },
        words       = { enabled = false },
    },

    keys = {
        { "<leader>t",  function() Snacks.picker.files() end,             desc = "Find Files" },
        { "gd",         function() Snacks.picker.lsp_definitions() end,   desc = "Goto Definition" },
        { "gD",         function() Snacks.picker.lsp_declarations() end,  desc = "Goto Declaration" },
        { "gr",         function() Snacks.picker.lsp_references() end,    nowait = true, desc = "References" },
        { "gI",         function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy",         function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>sb", function() Snacks.picker.lines() end,             desc = "Buffer Lines" },
        { "<leader>sC", function() Snacks.picker.commands() end,          desc = "Commands" },
    }
}
