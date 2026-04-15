--[[
Behaviors:
- Reserves bare `<Space>` and sets `mapleader` to space.
- Maps `<leader>qq`, `<leader>qa`, `<leader>qh`, `<leader>wq`, and `<leader>wqa` for quit, quit-all, force-quit, write-quit, and write-quit-all.
- Leaves the empty-line and non-empty-line navigation experiments commented out.
]]
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' ' -- 'vim.g' sets global variables

-- todo: shift h+l beginning of line -> previous/next beginning/end of line
-- go to end of previous word
-- map('n', 'be', 'ge', options)

-- quit mappings
map('n', '<leader>qq', ':q<cr>', options)    -- quit
map('n', '<leader>qa', ':qa<cr>', options)   -- quit all
map('n', '<leader>qh', ':q!<cr>', options)   -- quit hard
map('n', '<leader>wq', ':wq<cr>', options)   -- write quit
map('n', '<leader>wqa', ':wqa<cr>', options) -- write quit all

-- jump to empty & non-empty lines
-- map('n', '<leader>nel', "", options) -- next empty line
-- map('n', '<leader>pel', "", options) -- previous empty line
-- map('n', '<leader>pnl', ":<C-u>call search(\'&.\\+\', 'b')<cr>", options) -- previous non-empty line
-- extend to empty & non-empty lines
-- map('x', '<leader>nnl', "s<C-u>k`\\|call search(\'^.\\+\')\\|normal! <C-r>=visualmode()<CR>``o<CR>", options)
-- map('x', '<leader>pnl', "s<C-u>k`\\|call search(\'^.\\+\', \'b\')\\|normal! <C-r>=visualmode()<CR>``o<CR>", options)
