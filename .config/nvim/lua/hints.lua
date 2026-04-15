--[[
Behaviors:
- Maps `<leader>ht` to `:HopWord` for hint-based jump navigation.
- Leaves the tree-sitter hop experiments commented out, so only the single Hop mapping is active.
]]
local map = vim.api.nvim_set_keymap


local options = { noremap = true, silent = true }

-- hint
map('n', '<leader>ht', '<Cmd>:HopWord<CR>', options)

-- hint searching
-- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
-- vnoremap <silent> m :lua require('tsht').nodes()<CR>

-- TODO: remap {} go to next/previous block
-- map('n', '{',
