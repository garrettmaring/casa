--[[
Behaviors:
- Safe-loads `nvim-treesitter.configs` and returns without side effects if the plugin is unavailable.
- Enables Tree-sitter highlighting and indentation when available.
]]
local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

treesitter.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
