--[[
Behaviors:
- Returns early in headless sessions, then loads `hologram.nvim` only when the plugin is available.
- Calls `hologram.setup()` with default options and warns asynchronously if setup fails.
]]
-- display media such as images in vim

if #vim.api.nvim_list_uis() == 0 then
  return
end

local ok, hologram = pcall(require, 'hologram')
if not ok then
  return
end

local setup_ok, err = pcall(hologram.setup, {
  --auto_display = true -- WIP automatic markdown image display, may be prone to breaking
})

if not setup_ok then
  vim.schedule(function()
    vim.notify(("Skipping hologram setup: %s"):format(err), vim.log.levels.WARN)
  end)
end
