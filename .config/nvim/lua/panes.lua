-- Disable default kitty navigator mappings
vim.g.kitty_navigator_no_mappings = 1

-- Enhanced smart navigation function that integrates with kitty-navigator
local function smart_navigate(direction)
  local current_win = vim.api.nvim_get_current_win()
  local current_pos = vim.api.nvim_win_get_cursor(current_win)

  -- Try to move to another window
  vim.cmd('wincmd ' .. direction)

  -- If we didn't move (same window and cursor position), try kitty navigation
  if current_win == vim.api.nvim_get_current_win() and
      vim.deep_equal(current_pos, vim.api.nvim_win_get_cursor(current_win)) then
    -- Map direction to kitty command
    local kitty_cmd = {
      h = 'KittyNavigateLeft',
      j = 'KittyNavigateDown',
      k = 'KittyNavigateUp',
      l = 'KittyNavigateRight'
    }

    -- Execute the kitty navigation command
    if kitty_cmd[direction] then
      vim.cmd(':' .. kitty_cmd[direction])
    else
      -- Fallback to original behavior if direction not mapped
      local key = vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true)
      vim.api.nvim_feedkeys(key, 'n', false)
      -- Send the original keystroke through
      local ctrl_key = vim.api.nvim_replace_termcodes('<C-' .. direction .. '>', true, true, true)
      vim.api.nvim_feedkeys(ctrl_key, 'n', false)
    end
  end
end

-- Set up the mappings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Smart window navigation with Kitty integration
map('n', '<C-h>', function() smart_navigate('h') end, opts)
map('n', '<C-j>', function() smart_navigate('j') end, opts)
map('n', '<C-k>', function() smart_navigate('k') end, opts)
map('n', '<C-l>', function() smart_navigate('l') end, opts)

-- Also work in terminal mode
map('t', '<C-h>', function() smart_navigate('h') end, opts)
map('t', '<C-j>', function() smart_navigate('j') end, opts)
map('t', '<C-k>', function() smart_navigate('k') end, opts)
map('t', '<C-l>', function() smart_navigate('l') end, opts)

-- Direct Kitty navigation commands (can be used if needed)
vim.cmd([[
  nnoremap <silent> <leader>kh :KittyNavigateLeft<CR>
  nnoremap <silent> <leader>kj :KittyNavigateDown<CR>
  nnoremap <silent> <leader>kk :KittyNavigateUp<CR>
  nnoremap <silent> <leader>kl :KittyNavigateRight<CR>
]])
