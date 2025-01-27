local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
-- Setup For Mini.Tabline
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
    callback = function(args)
        if vim.bo[args.buf].buftype == "" and vim.api.nvim_buf_get_name(args.buf) == "" then
            vim.bo[args.buf].buflisted = false
        end
    end,
})
-- Floating
autocmd(
    {"CursorHold"},
    {
        group = augroup("float_diagnostic", {clear = true}),
        callback = function()
            vim.diagnostic.open_float(nil, {focus = false})
        end
    }
)
-- highlights yanked text
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                higroup = "IncSearch",
                timeout = 40,
            })
        end,
    })
-- Dim inactive windows
vim.cmd("highlight default DimInactiveWindows guifg=#666666")
-- When leaving a window, set all highlight groups to a "dimmed" hl_group
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    callback = function()
        local highlights = {}
        for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
            table.insert(highlights, hl .. ":DimInactiveWindows")
        end
        vim.wo.winhighlight = table.concat(highlights, ",")
    end,
})
-- When entering a window, restore all highlight groups to original
vim.api.nvim_create_autocmd({ "WinEnter" }, {
    callback = function()
        vim.wo.winhighlight = ""
    end,
})
vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = vim.api.nvim_create_augroup(
        'gmr_cmdheight_1_on_cmdlineenter',
        { clear = true }
    ),
    desc = 'Don\'t hide the status line when typing a command',
    command = ':set cmdheight=1',
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = vim.api.nvim_create_augroup(
        'gmr_cmdheight_0_on_cmdlineleave',
        { clear = true }
    ),
    desc = 'Hide cmdline when not typing a command',
    command = ':set cmdheight=0',
})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup(
        'gmr_hide_message_after_write',
        { clear = true }
    ),
    desc = 'Get rid of message after writing a file',
    pattern = { '*' },
    command = 'redrawstatus',
})
-- Don't insert new line after comment
local augroup = vim.api.nvim_create_augroup("useful", { clear = true })
-- Create the autocommand
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = augroup,
    callback = function()
        vim.cmd("set formatoptions-=cro")
    end,
})
