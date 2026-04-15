--[[
Behaviors:
- Reserves this file for `refactoring.nvim` integration without colliding with the plugin's `refactoring` module name.
- Keeps the planned setup and mappings (`<leader>re`, `rf`, `rv`, `rI`, `ri`, `rb`, `rbf`, `rr`) commented out, so it currently adds no editor behavior.
]]
-- `refactoring` is an existing third-party module name, hence the `_` prefix.
-- TOOD: better refactoring, see lsp for current rename
--require('refactoring').setup()
--vim.keymap.set("x", "<leader>re", function() require('refactoring').refactor('Extract Function') end)
--vim.keymap.set("x", "<leader>rf", function() require('refactoring').refactor('Extract Function To File') end)
---- Extract function supports only visual mode
--vim.keymap.set("x", "<leader>rv", function() require('refactoring').refactor('Extract Variable') end)
---- Extract variable supports only visual mode
--vim.keymap.set("n", "<leader>rI", function() require('refactoring').refactor('Inline Function') end)
---- Inline func supports only normal
--vim.keymap.set({ "n", "x" }, "<leader>ri", function() require('refactoring').refactor('Inline Variable') end)
---- Inline var supports both normal and visual mode

--vim.keymap.set("n", "<leader>rb", function() require('refactoring').refactor('Extract Block') end)
--vim.keymap.set("n", "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end)
---- Extract block supports only normal mode
--vim.keymap.set(
--{ "n", "x" },
--"<leader>rr",
--function() require('refactoring').select_refactor() end
--)
