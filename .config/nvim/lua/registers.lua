local map = vim.api.nvim_set_keymap


options = { noremap = true, silent = true }

map('n', '<C-p>', '<Cmd>:Registers<CR>', options)
map('i', '<C-p>', '<ESC>:Registers<CR>', options)
