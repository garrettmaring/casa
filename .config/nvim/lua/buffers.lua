-- Create module table
local M = {}

local map = vim.keymap.set
--local opts = { noremap = true, silent = true }

-- Enable hidden buffers (allows switching without saving)
vim.opt.hidden = true

-- Buffer management mappings with <leader>b prefix
-- Main buffer operations
map('n', '<leader>bb', '<C-^>', { desc = 'Switch to alternate buffer', noremap = true })
map('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer', noremap = true })
map('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer', noremap = true })

-- Buffer listing and selection
map('n', '<leader>bl', ':buffers<CR>', { desc = 'List all buffers', noremap = true })
map('n', '<leader>bg', ':buffers<CR>:buffer<Space>', { desc = 'Go to buffer (by number)', noremap = true })

-- Buffer deletion and saving
map('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete current buffer', noremap = true })
map('n', '<leader>bD', ':bdelete!<CR>', { desc = 'Force delete current buffer', noremap = true })
map('n', '<leader>bw', ':write<CR>', { desc = 'Write buffer', noremap = true })

-- Buffer navigation through jumplist
map('n', '[b', '<C-o>', { desc = 'Go to previous jump position', noremap = true })
map('n', ']b', '<C-i>', { desc = 'Go to next jump position', noremap = true })

-- If you're using Telescope, add these enhanced buffer operations
local ok, telescope = pcall(require, 'telescope.builtin')
if ok then
  -- Enhanced buffer selection with Telescope
  map('n', '<leader>bs', function() telescope.buffers() end, { desc = 'Search buffers', noremap = true })
end

-- Add buffer count function to module
function M.get_buffer_count()
  return #vim.fn.getbufinfo({ buflisted = 1 })
end

-- Optional: Add buffer count to statusline
local current_stl = vim.opt.statusline:get()
vim.opt.statusline = current_stl .. '%{%v:lua.require("buffers").get_buffer_count()%}'

-- Buffer commands for command mode
vim.cmd([[
  " Allow switching to any buffer with :B
  command! -nargs=1 B :buffer <args>

  " Allow switching to any buffer with partial name matching
  command! -nargs=1 -complete=buffer Bs :buffers<CR>:buffer <args>
]])

-- Add buffer autocommands
local buffer_group = vim.api.nvim_create_augroup('BufferConfig', { clear = true })

-- Automatically equalize windows when terminal is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = buffer_group,
  pattern = '*',
  command = 'wincmd =',
})

-- Optional: Auto-save buffers when leaving them
vim.api.nvim_create_autocmd('BufLeave', {
  group = buffer_group,
  pattern = '*',
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand('%') ~= '' then
      vim.api.nvim_command('silent update')
    end
  end,
})

-- Return the module
return M
