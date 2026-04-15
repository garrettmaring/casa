--[[
Behaviors:
- Maps `<leader>mmr` to `:Reload` (plus the current `:echo 'hi'` side effect) and `<leader>mmrp` to `:Reload | PackerSync`.
]]
--- config & plugin management
-- refresh configuration by reloading all modules
vim.keymap.set('n', '<leader>mmr', "<cmd>Reload<cr> <bar> :echo 'hi'<cr>")
-- refresh configuration & resync plugins
vim.keymap.set('n', '<leader>mmrp', '<cmd>Reload<cr> <bar> PackerSync<cr>')
