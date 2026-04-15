--[[
Behaviors:
- Returns compatibility aliases from legacy `report_*` names to the modern `vim.health.*` API for plugins that still expect the old interface.
]]
return {
  report_start = vim.health.start,
  report_info = vim.health.info,
  report_ok = vim.health.ok,
  report_warn = vim.health.warn,
  report_error = vim.health.error,
}
