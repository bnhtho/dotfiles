-- Keybind
local builtin = require('telescope.builtin')
-- Buffer
vim.keymap.set('n', 'L', '<cmd>:bnext<Cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', 'H', '<cmd>:bprevious<Cr>', { desc = 'Previous Buffer' })
--- Split 
vim.keymap.set('n','sj','<cmd>:split<CR>',{desc = "Horizional Split"})
vim.keymap.set('n','sl','<cmd>:vsplit<CR>',{desc = "Vertical Split"})
-- Normal Mode Window Navigation (Keep it consistent and simple)
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Move focus to the right window' })