vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "14.2")

local data_bin = vim.fn.stdpath("data") .. "/casa-bin"
if vim.fn.isdirectory(data_bin) == 1 then
  vim.env.PATH = data_bin .. ":" .. vim.env.PATH
end

-- Neovim 0.11 deprecates vim.tbl_islist; older plugins still call it.
if vim.islist then
  vim.tbl_islist = vim.islist
end

-- Older plugins still call vim.tbl_flatten, which is deprecated on 0.12.
vim.tbl_flatten = function(t)
  local result = {}

  local function flatten(value)
    if type(value) == "table" and vim.islist(value) then
      for _, item in ipairs(value) do
        flatten(item)
      end
      return
    end

    table.insert(result, value)
  end

  flatten(t)
  return result
end

-- Newer nvim-treesitter removed the legacy configs module, but older plugins
-- like Telescope still require a few helpers from it.
local ts_legacy_modules = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
}

local function ts_legacy_get_module(name)
  local module = ts_legacy_modules[name]
  if not module then
    module = {}
    ts_legacy_modules[name] = module
  end
  return module
end

local function ts_legacy_is_disabled(disable, lang, bufnr)
  if type(disable) == "function" then
    local ok, disabled = pcall(disable, lang, bufnr)
    return ok and disabled or false
  end

  if type(disable) == "table" then
    if lang and vim.list_contains(disable, lang) then
      return true
    end

    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      local ft = vim.bo[bufnr].filetype
      if ft ~= "" and vim.list_contains(disable, ft) then
        return true
      end
    end
  end

  return false
end

package.preload["nvim-treesitter.configs"] = package.preload["nvim-treesitter.configs"] or function()
  local M = {}

  function M.setup(user_data)
    for name, opts in pairs(user_data or {}) do
      ts_legacy_modules[name] = vim.tbl_deep_extend("force", ts_legacy_get_module(name), opts)
    end
  end

  function M.get_module(name)
    return ts_legacy_get_module(name)
  end

  function M.is_enabled(name, lang, bufnr)
    local module = ts_legacy_get_module(name)
    if module.enable ~= true then
      return false
    end
    if ts_legacy_is_disabled(module.disable, lang, bufnr) then
      return false
    end
    if bufnr and lang then
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
      return ok and parser ~= nil
    end
    return true
  end

  function M.get_parser_configs()
    local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
    return ok and ts_parsers or {}
  end

  return M
end

-- Telescope and other older plugins still call the removed Tree-sitter API.
if vim.treesitter and vim.treesitter.language and vim.treesitter.language.get_lang and not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end
do
  local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
  if ok and not ts_parsers.ft_to_lang and vim.treesitter and vim.treesitter.language and vim.treesitter.language.get_lang then
    ts_parsers.ft_to_lang = vim.treesitter.language.get_lang
  end
  if ok and not ts_parsers.get_parser then
    ts_parsers.get_parser = function(bufnr, lang)
      return vim.treesitter.get_parser(bufnr, lang)
    end
  end
  if ok and not ts_parsers.has_parser then
    ts_parsers.has_parser = function(lang)
      return pcall(vim.treesitter.language.add, lang)
    end
  end
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
