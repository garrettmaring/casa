local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

require("symbols-outline").setup()

map('n', 'ss', ':SymbolsOutline', options)
