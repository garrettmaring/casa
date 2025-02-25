local o = vim.o
local g = vim.g -- global options
local cmd = vim.cmd

o.termguicolors = true

-- base theme
cmd 'colorscheme edge'
g.edge_style = 'default'
g.edge_better_performance = 1
