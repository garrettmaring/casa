--[[
Behaviors:
- Enables `termguicolors`, sets the Edge theme globals (`edge_style` and `edge_better_performance`), and applies `colorscheme edge` with `pcall`.
]]
local o = vim.o
local g = vim.g -- global options
local cmd = vim.cmd

o.termguicolors = true

-- base theme
g.edge_style = 'default'
g.edge_better_performance = 1
pcall(cmd, 'colorscheme edge')
