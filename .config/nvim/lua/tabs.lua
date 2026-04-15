--[[
Behaviors:
- Maps `<C-D-[>` and `<C-D-]>` to Barbar previous/next buffer-tab navigation.
- Maps `<leader>cb` and `<leader>bc` to `:BufferClose`.
]]
-- buffer tab management

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- buffer tabs browser-like navigation (kitty needs to be configured properly for this to work)
map('n', '<C-D-]>', ':BufferNext<cr>', options)
map('n', '<C-D-[>', ':BufferPrevious<cr>', options)

map('n', '<leader>cb', ':BufferClose<cr>', options) -- close buffer
map('n', '<leader>bc', ':BufferClose<cr>', options) -- buffer close (maybe a more general us naming pattern)

-- TODO: always sort by directory

-- NOTE: if setting the file tree on the right side, this can be used to offset the tabs position
--local nvim_tree_events = require('nvim-tree.events')
--local bufferline_api = require('bufferline.api')

--local function get_tree_size()
  --return require'nvim-tree.view'.View.width
--end

--nvim_tree_events.subscribe('TreeOpen', function()
  --bufferline_api.set_offset(get_tree_size())
--end)

--nvim_tree_events.subscribe('Resize', function()
  --bufferline_api.set_offset(get_tree_size())
--end)

--nvim_tree_events.subscribe('TreeClose', function()
  --bufferline_api.set_offset(0)
--end)
