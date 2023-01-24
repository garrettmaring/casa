local map = vim.api.nvim_set_keymap

-- map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables


options = { noremap = true, silent = true }

-- clear search highlight
map('n', '<leader>ch', ':nohlsearch<cr>', options)

-- buffer tabs browser-like navigation (kitty needs to be configured properly for this to work)
map('n', '<CHAR-0x0b>]', '<D-]>', {})
map('n', '<CHAR-0x0b>[', '<D-[>', {})
map('n', '<C-D-]>', ':BufferNext<cr>', options)
map('n', '<C-D-[>', ':BufferPrevious<cr>', options)

-- todo: shift h+l beginning of line -> previous/next beginning/end of line

-- go to end of previous word
map('n', 'be', 'ge', options)

map('n', '<leader>cb', ':BufferClose<cr>', options) -- close buffer
map('n', '<leader>qq', ':q<cr>', options) -- quit
map('n', '<leader>qa', ':qa<cr>', options) -- quit all
map('n', '<leader>qh', ':q!<cr>', options) -- quit hard
map('n', '<leader>wq', ':wq<cr>', options) -- write quit
map('n', '<leader>wqa', ':wqa<cr>', options) -- write quit all

-- "kuick" (quick) exit commands
map('i', '<leader>wk', '<esc>:w<cr> e', options)
map('i', '<leader>jk', '<esc> e', options)

-- file tree
map('n', '<leader>fo', ':NvimTreeFindFile<cr>', options)
map('n', '<leader>fto', ':NvimTreeOpen<cr>', options)
map('n', '<leader>ftc', ':NvimTreeClose<cr>', options)

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

-- file search (telescope)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
