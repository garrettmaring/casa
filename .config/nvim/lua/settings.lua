local o = vim.o
local g = vim.g -- global options
local wo = vim.wo

-- mouse
o.mouse = o.mouse .. 'a'

-- global options
o.swapfile = true
o.dir = '/tmp'
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.clipboard = 'unnamedplus'

-- window-local options
wo.number = false
wo.wrap = true      -- wrap text so no horizontal scroll
wo.linebreak = true -- wrap text so no horizontal scroll

-- set custom filetypes if not supported
-- cmd('au BufNewFile,BufRead * if &filetype == "" | set ft=text | endif')

-- do not source the default filetype
g.did_load_filtypes = 1
