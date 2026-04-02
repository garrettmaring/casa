local function load_env_file(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return false
  end

  for line in file:lines() do
    -- Ignore empty lines and comments
    if line:match("^%s*#") or line:match("^%s*$") then
      goto continue
    end

    -- Parse key-value pairs
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)%s*$")
    if key and value then
      -- Remove quotes if present
      value = value:gsub('^["\']', ''):gsub('["\']$', '')
      vim.fn.setenv(key, value)
    end

    ::continue::
  end

  file:close()
  return true
end

local config_dir = vim.fn.stdpath('config')

-- Load repo defaults first, then local-only overrides.
load_env_file(config_dir .. '/.env')
load_env_file(config_dir .. '/.env.local')

-- ---------------------------------------------------------------------------
-- Ensure Mason-installed binaries are on PATH so that Neovim can spawn the
-- corresponding language-servers no matter how it is launched (terminal,
-- GUI, or embedded).
-- ---------------------------------------------------------------------------
local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'

-- Prepend only if it's not already present to avoid endlessly extending PATH
if not tostring(vim.env.PATH):find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ':' .. vim.env.PATH
end
