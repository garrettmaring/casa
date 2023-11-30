local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

-- clear search highlight
map('n', '<leader>ch', ':nohlsearch<cr>', options)

-- todo: shift h+l beginning of line -> previous/next beginning/end of line

-- go to end of previous word
-- map('n', 'be', 'ge', options)

map('n', '<leader>qq', ':q<cr>', options) -- quit
map('n', '<leader>qa', ':qa<cr>', options) -- quit all
map('n', '<leader>qh', ':q!<cr>', options) -- quit hard
map('n', '<leader>wq', ':wq<cr>', options) -- write quit
map('n', '<leader>wqa', ':wqa<cr>', options) -- write quit all

-- "kuick" (quick) exit commands
map('i', '<leader>kw', '<esc>:w<cr>', options)
map('i', '<leader>kk', '<esc>', options)

-- terminal (kitty) + neovim navigation
map('n', '<C-l>', ':KittyNavigateRight<cr>', options)
map('n', '<C-h>', ':KittyNavigateLeft<cr>', options)

-- hint searching
-- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
-- vnoremap <silent> m :lua require('tsht').nodes()<CR>

-- TODO: remap {} go to next/previous block
-- map('n', '{', 

-- jump to empty & non-empty lines
-- map('n', '<leader>nel', "", options) -- next empty line
-- map('n', '<leader>pel', "", options) -- previous empty line
-- map('n', '<leader>pnl', ":<C-u>call search(\'&.\\+\', 'b')<cr>", options) -- previous non-empty line
-- extend to empty & non-empty lines
-- map('x', '<leader>nnl', "s<C-u>k`\\|call search(\'^.\\+\')\\|normal! <C-r>=visualmode()<CR>``o<CR>", options)
-- map('x', '<leader>pnl', "s<C-u>k`\\|call search(\'^.\\+\', \'b\')\\|normal! <C-r>=visualmode()<CR>``o<CR>", options)

-- cut
map('n', 'x', 'd', options)
map('x', 'x', 'xl', options)
map('n', 'xx', 'dd', options)
map('n', 'X', 'D', options)

-- replace
-- substitues with text objects
map('n', 's', '<Cmd>:SubversiveSubstitute<CR>', options)
map('n', 'ss', '<Cmd>:SubversiveSubstituteLine<CR>', options)
map('n', 'S', '<Cmd>:SubversiveSubstituteToEndOfLine<CR>', options)
