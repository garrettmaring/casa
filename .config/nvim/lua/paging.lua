local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Ergonomic paging motions on the home row.
-- `<D-...>` is the macOS Command key in UIs that forward it to Neovim.
map('n', '<D-j>', '<C-d>zz', opts) -- half-page down
map('n', '<D-k>', '<C-u>zz', opts) -- half-page up
map('n', '<D-f>', '<C-f>zz', opts) -- full-page forward
map('n', '<D-b>', '<C-b>zz', opts) -- full-page backward

-- `<M-...>` remains the terminal-friendly Option/Alt fallback.
map('n', '<M-j>', '<C-d>zz', opts) -- half-page down
map('n', '<M-k>', '<C-u>zz', opts) -- half-page up
map('n', '<M-f>', '<C-f>zz', opts) -- full-page forward
map('n', '<M-b>', '<C-b>zz', opts) -- full-page backward

-- Keep hardware paging keys centered as well.
map('n', '<PageDown>', '<C-f>zz', opts)
map('n', '<PageUp>', '<C-b>zz', opts)
