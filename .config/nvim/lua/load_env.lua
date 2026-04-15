--[[
Behaviors:
- Loads `.env` first and `.env.local` second from the Neovim config directory into the current process environment.
- Backfills `AVANTE_*_API_KEY` variables from older shared `*_API_KEY` names when the Avante-scoped names are missing.
- Prepends Mason's `bin` directory to `PATH` once so GUI and terminal Neovim sessions can spawn installed tooling.
]]
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

local function set_env_fallback(target_key, source_key)
  local current_value = vim.env[target_key]
  if current_value and current_value ~= "" then
    return
  end

  local source_value = vim.env[source_key]
  if source_value and source_value ~= "" then
    vim.fn.setenv(target_key, source_value)
  end
end

local config_dir = vim.fn.stdpath('config')

-- Load repo defaults first, then local-only overrides.
load_env_file(config_dir .. '/.env')
load_env_file(config_dir .. '/.env.local')

-- Prefer Avante-scoped credentials, but preserve compatibility with older
-- shared env var names that may still exist in an untracked local file.
set_env_fallback("AVANTE_ANTHROPIC_API_KEY", "ANTHROPIC_API_KEY")
set_env_fallback("AVANTE_OPENAI_API_KEY", "OPENAI_API_KEY")
set_env_fallback("AVANTE_GEMINI_API_KEY", "GEMINI_API_KEY")
set_env_fallback("AVANTE_GROQ_API_KEY", "GROQ_API_KEY")

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
