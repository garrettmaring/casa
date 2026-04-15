--[[
Behaviors:
- Disables NERDCommenter's default mappings and remaps `<leader>cc` in normal and visual mode to `NERDCommenterToggle`.
]]
-- crispy comments 🥓

local g = vim.g -- global options
local map = vim.api.nvim_set_keymap

g.NERDCreateDefaultMappings = 0 -- we'll configure our own commenter mappings

local options = { noremap = true, silent = true }

map('n', '<leader>cc', '<Plug>NERDCommenterToggle<CR>', options)
map('x', '<leader>cc', '<Plug>NERDCommenterToggle<CR>', options)
