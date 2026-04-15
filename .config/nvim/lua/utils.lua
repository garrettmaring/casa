--[[
Behaviors:
- Exports `create_augroup(autocmds, name)`, a helper that turns simple table specs into augroup + autocommand definitions via `vim.cmd`.
]]
local M = {}
local cmd = vim.cmd

function M.create_augroup(autocmds, name)
    cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

return M
