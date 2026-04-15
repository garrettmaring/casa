--[[
Behaviors:
- Requires `specs.nvim` so the plugin loads, but leaves all custom animation settings commented out.
- Applies no explicit cursor mappings or overrides here, so `specs.nvim` defaults remain in effect unless configured elsewhere.
]]
-- customize the cursor
--
-- @see https://github.com/edluffy/specs.nvim

local specs = require('specs')
--require('specs').setup {
--show_jumps       = true,
--min_jump         = 30,
--popup            = {
--delay_ms = 0,     -- delay before popup displays
--inc_ms = 10,      -- time increments used for fade/resize effects
--blend = 10,       -- starting blend, between 0-100 (fully transparent), see :h winblend
--width = 10,
--winhl = "PMenu",
--fader = require('specs').linear_fader,
--resizer = require('specs').shrink_resizer
--},
--ignore_filetypes = {},
--ignore_buftypes  = {
--nofile = true,
--},
--}
