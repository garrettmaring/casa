--[[
Behaviors:
- Maps `<leader>ch` to `:nohlsearch` to clear search highlighting.
]]
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- clear search highlight
map('n', '<leader>ch', ':nohlsearch<cr>', options)
