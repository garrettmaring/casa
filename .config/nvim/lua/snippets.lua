--[[
Behaviors:
- Lazy-loads `friendly-snippets` into LuaSnip through the VS Code snippet loader and defines no extra mappings or custom snippet files here.
]]
-- snippets.lua
-- 
-- snippets are used in autocompletion as well
-- friendly snippets should be added by default

-- load friendly-snippets in vscode style
require('luasnip.loaders.from_vscode').lazy_load()
