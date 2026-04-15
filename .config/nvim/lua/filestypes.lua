--[[
Behaviors:
- Uses `filetype.nvim` overrides to disable syntax highlighting for `Brewfile` and treat `dash` shebang scripts as `sh`.
]]
require("filetype").setup({
    overrides = {
        function_literal = {
            Brewfile = function()
                vim.cmd("syntax off")
            end,
        },

        shebang = {
            -- Set the filetype of files with a dash shebang to sh
            dash = "sh",
        },
    },
})
