--[[
Behaviors:
- Maps `Ctrl-p` in normal and insert mode to open `:Registers`.
]]
local map = vim.api.nvim_set_keymap


local options = { noremap = true, silent = true }

map('n', '<C-p>', '<Cmd>:Registers<CR>', options)
map('i', '<C-p>', '<ESC>:Registers<CR>', options)
