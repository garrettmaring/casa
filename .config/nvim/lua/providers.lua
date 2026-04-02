-- providers.lua
--
-- configure neovims python providers
--
-- create virtual envs with `pyenv virtualenv 3.9.10 vim-3.9.10` and put paths here. can then install pip packages to those envs

local g = vim.g
local home = vim.env.HOME or ""
local pyenv_root = vim.env.PYENV_ROOT or (home .. "/.pyenv")
local node_host = vim.fn.exepath("neovim-node-host")
local ruby_host = home .. "/.rbenv/shims/neovim-ruby-host"

local function is_executable(path)
  return vim.fn.executable(path) == 1
end

local function set_provider(var_name, relative_path)
  local executable = pyenv_root .. relative_path
  if is_executable(executable) then
    g[var_name] = executable
  end
end

local function virtualenv_has_python(venv)
  local expanded = vim.fn.expand(venv)
  return is_executable(expanded .. "/bin/python") or is_executable(expanded .. "/bin/python3")
end

g.loaded_perl_provider = 0

if vim.env.VIRTUAL_ENV and not virtualenv_has_python(vim.env.VIRTUAL_ENV) then
  vim.env.VIRTUAL_ENV = nil
end

set_provider("python3_host_prog", "/versions/3.9.10/envs/vim-3.9.10/bin/python")
set_provider("python_host_prog", "/versions/2.7.18/envs/vim-2.7.18/bin/python")

if is_executable(ruby_host) then
  g.ruby_host_prog = ruby_host
end

if node_host ~= "" then
  g.node_host_prog = node_host
end
