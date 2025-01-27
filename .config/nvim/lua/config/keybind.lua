-- Keybind
local builtin = require('telescope.builtin')
-- Buffer
vim.keymap.set('n', 'L', '<cmd>:bnext<Cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', 'H', '<cmd>:bprevious<Cr>', { desc = 'Previous Buffer' })
-- Normal Mode Window Navigation (Keep it consistent and simple)
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Move focus to the right window' })
-- Keymap: Set KJ to move line up/down in Normal/Visual Mode
-- Select All
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')
-- telescope
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>r', builtin.live_grep, {})
vim.keymap.set('n', '<leader>o', builtin.oldfiles,{})
