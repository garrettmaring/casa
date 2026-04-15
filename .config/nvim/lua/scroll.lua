--[[
Behaviors:
- Remaps `Ctrl-w` to half-page up and `Ctrl-z` to half-page down in normal mode.
]]
-- Remap keys for scrolling
vim.api.nvim_set_keymap('n', '<C-w>', '<C-U>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-z>', '<C-D>', { noremap = true, silent = true })
