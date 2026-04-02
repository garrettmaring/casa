vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "14.2")

local data_bin = vim.fn.stdpath("data") .. "/casa-bin"
if vim.fn.isdirectory(data_bin) == 1 then
  vim.env.PATH = data_bin .. ":" .. vim.env.PATH
end

-- Neovim 0.11 deprecates vim.tbl_islist; older plugins still call it.
if vim.islist then
  vim.tbl_islist = vim.islist
end

-- Older plugins still require the legacy `health` module name.
package.preload["health"] = package.preload["health"] or function()
  return {
    report_start = vim.health.start,
    report_info = vim.health.info,
    report_ok = vim.health.ok,
    report_warn = vim.health.warn,
    report_error = vim.health.error,
  }
end

-- Symbols-outline and similar plugins still call the deprecated API.
if vim.lsp and vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(bufnr)
    if type(bufnr) == "table" then
      return vim.lsp.get_clients(bufnr)
    end
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
end

if vim.env.CASA_NVIM_BOOTSTRAP == "1" then
  require("plugins")
  if vim.env.CASA_NVIM_BOOTSTRAP_LOAD_PLUGINS == "1" then
    vim.cmd("silent! packloadall")
  end
  return
end


require('packer.luarocks').install_commands()
require("load_env")
require("colors")
require('providers')      -- neovim python providers
require('maps')           -- keybindings
require('statusline')     -- custom statusline
require('plugins')        -- packer plugins
require('lsp')            -- language servers
require('autocomplete')   -- completion
require('snippets')       -- snippet settings
require('search')         -- searching
require('filestypes')     -- faster/customer file type
require('mail')           -- email
require('filetree')       -- file tree settings
require('registers')      -- copy pasta 🍝
require('hints')          -- easy motion
require('commenting')     -- nerdcommenter settings
require('git')            -- totally Torvalds
require('gitsigns')       -- gitsigns plugin configuration
require('rust')           -- configure Rust debugger
require('cursor')         -- customize the cursor
require('diagnostics')    -- diagnostics settings
require('tabs')           -- buffers & tab viewing
require('splits')         -- lickity-split splits
require('_refactoring')   -- easy robust refactoring
require('replace')        -- replacing seleted text (outside refactoring)
require('media')          -- images, videos, audio
require('symbols')
require("metamanagement") -- specifics for working on the workbench
require('settings')       -- misc settings
require('alfred')         -- there's nothing i don't
require('syntax_highlighting')
require('ai')
require('panes')
require('clipboard')
require('folds')
require('highlights')
require('editing')
require('buffers')
require('scroll')
