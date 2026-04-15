--[[
Behaviors:
- Sets `splitbelow`, `splitright`, and `splitkeep=screen` so new splits open predictably without shifting the main layout.
- Maps `<leader>ssh` / `<leader>ssv` for horizontal and vertical splits, plus `<C-D-h/j/k/l>` for window focus moves.
]]
-- splits

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
local opt = vim.opt

opt.splitbelow = true
opt.splitright = true

-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
opt.splitkeep = "screen"

map('n', '<leader>ssh', '<CMD>:split<CR>', options)
map('n', '<leader>ssv', '<CMD>:vsplit<CR>', options)

map('n', '<C-D-h>', '<C-W><C-H>', options)
map('n', '<C-D-j>', '<C-W><C-J>', options)
map('n', '<C-D-k>', '<C-W><C-K>', options)
map('n', '<C-D-l>', '<C-W><C-L>', options)
