local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>ch', ':nohlsearch<cr>', options)

vim.opt.foldmethod = 'syntax'

-- Let's keep the original vim mappings as they are intuitive:
-- zf: Create a fold (in manual fold mode)
-- zo: Open current fold under cursor
-- zc: Close current fold under cursor
-- za: Toggle current fold under cursor (open if closed, close if open)
-- zR: Open all folds in buffer
-- zM: Close all folds in buffer

-- Additional fold navigation with centering
map('n', '<leader>zj', 'zjzz', options) -- Move to next fold and center screen
map('n', '<leader>zk', 'zkzz', options) -- Move to previous fold and center screen
map('n', '<leader>z[', '[zzz', options) -- Move to start of open fold and center
map('n', '<leader>z]', ']zzz', options) -- Move to end of open fold and center

-- Adjust fold levels
map('n', '<leader>z+', ':lua for i=1,v:count1 do fold.increment() end<CR>', options)
map('n', '<leader>z-', ':lua for i=1,v:count1 do fold.decrement() end<CR>', options)

-- Helper functions for adjusting fold levels
local fold = {}

function fold.increment()
  local foldlevel = vim.wo.foldlevel
  vim.wo.foldlevel = foldlevel + 1
end

function fold.decrement()
  local foldlevel = vim.wo.foldlevel
  if foldlevel > 0 then
    vim.wo.foldlevel = foldlevel - 1
  end
end
