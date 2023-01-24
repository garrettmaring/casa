local map = vim.api.nvim_set_keymap


local options = { noremap = true, silent = true }

-- hint
map('n', 'H', '<Cmd>:HopWord<CR>', options)
