--[[
Behaviors:
- Uses `utils.create_augroup` to mark `/tmp/nail-*` and `*s-nail-*` buffers as `mail` on `BufRead` / `BufNewFile`.
]]
local u = require('utils')

-- set mail filetype
u.create_augroup({
    { 'BufRead,BufNewFile', '/tmp/nail-*', 'setlocal', 'ft=mail' },
    { 'BufRead,BufNewFile', '*s-nail-*', 'setlocal', 'ft=mail' },
}, 'ftmail')
