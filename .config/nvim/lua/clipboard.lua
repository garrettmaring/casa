--[[
Behaviors:
- Remaps `P` to open a new line above and paste there, with `Bp` preserving the original paste-before behavior.
- Remaps `x`, visual `x`, `xx`, and `X` to cut character, selection edge, whole line, and rest-of-line text instead of the stock defaults.
]]
-- clipboard: copying, pasting, duplicating, clipboard history

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- map shift+p (P) in normal mode to paste correctly into the line above
-- This mapping uses `m`` to set a mark, `O` to open a new line above, `<ESC>` to exit insert mode, and `p` to paste the text. The cursor will return to its original position[1].
map('n', 'P', 'm`O<ESC>p``', options)

-- remap deault P behavior (paste before cursor)
-- using B instad of b because delaying reading of 'b' feels terrible in normal mode when using it to get 'back word' (it slows down that movement)
map('n', 'Bp', 'P', options)

-- cut
map('n', 'x', 'd', options)
map('x', 'x', 'xl', options)
map('n', 'xx', 'dd', options)
map('n', 'X', 'D', options)
