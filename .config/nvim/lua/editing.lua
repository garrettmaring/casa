local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.numberwidth = 2

-- write 'kuick'
map('i', '<leader>kw', '<esc>:w<cr>', options)
map('n', '<leader>kw', ':w<cr>', options)
-- jump (out of insert) 'kuick' (either way)
map('i', '<leader>kj', '<esc>', options)
map('i', '<leader>jk', '<esc>', options)

-- replace
-- substitues with text objects
map('n', 's', '<Cmd>:SubversiveSubstitute<CR>', options)
map('n', 'ss', '<Cmd>:SubversiveSubstituteLine<CR>', options)
map('n', 'S', '<Cmd>:SubversiveSubstituteToEndOfLine<CR>', options)
