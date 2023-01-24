local g = vim.g -- global options
local map = vim.api.nvim_set_keymap

g.NERDCreateDefaultMappings = 0

options = { noremap = true, silent = true }

map('n', '<leader>cc', '<Plug>NERDCommenterComment<CR>', options)
map('x', '<leader>cc', '<Plug>NERDCommenterComment<CR>', options)
