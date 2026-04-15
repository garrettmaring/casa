--[[
Behaviors:
- Bootstraps `mason.nvim`, `mason-lspconfig`, `nvim-lspconfig`, and `cmp_nvim_lsp`, ensuring a base server set plus `csharp_ls` when `dotnet` is available.
- Exposes shared `on_attach` buffer maps for `K`, `gd`, `gD`, `gr`, `gi`, `<leader>rn`, and `<leader>ca`, attaches `nvim-navic` when possible, and adds Rust-specific `<D-space>` / `<Leader>a` bindings.
- Configures `lua_ls` and Solidity explicitly, adds `LspAttach`-driven format-on-save for clients that support formatting, and forces rounded hover/signature borders.
]]
-- ~/.config/nvim/lua/_lsp.lua

local M = {}

-- Load dependencies
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  vim.notify("Error: lspconfig not found", vim.log.levels.ERROR)
  return
end

local has_mason, mason = pcall(require, 'mason')
if not has_mason then
  vim.notify("Error: mason.nvim not found", vim.log.levels.ERROR)
  return
end

local has_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not has_mason_lsp then
  vim.notify("Error: mason-lspconfig.nvim not found", vim.log.levels.ERROR)
  return
end

local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if not has_cmp_lsp then
  vim.notify("Error: cmp_nvim_lsp not found", vim.log.levels.ERROR)
end

-- Setup mason (if needed)
mason.setup()

local ensure_installed = {
  "lua_ls",
  "html",
  "cssls",
  "pyright",
  "rust_analyzer",
  "tailwindcss",
  "ts_ls",
}

if vim.fn.executable("dotnet") == 1 then
  table.insert(ensure_installed, "csharp_ls")
end

-- Setup mason-lspconfig with ensure_installed and optional automatic_enable
mason_lspconfig.setup({
  ensure_installed = ensure_installed,
  -- If you want to disable automatic enabling for some servers or altogether:
  -- automatic_enable = true, -- default
  -- automatic_enable = { exclude = { "rust_analyzer", "tsserver" } },
})

-- Setup default capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
if has_cmp_lsp then
  capabilities = vim.tbl_deep_extend(
    "force",
    capabilities,
    cmp_lsp.default_capabilities(capabilities)
  )
end

-- Optional common on_attach function
local function on_attach(client, bufnr)
  -- navic
  local has_navic, navic = pcall(require, "nvim-navic")
  if has_navic
    and type(navic) == "table"
    and type(navic.attach) == "function"
    and client.server_capabilities.documentSymbolProvider
  then
    pcall(navic.attach, client, bufnr)
  end

  -- buffer local keymaps
  local bufmap = function(mode, lhs, rhs, desc)
    if desc then
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    else
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
    end
  end

  bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  bufmap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  bufmap("n", "gr", vim.lsp.buf.references, "References")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

  if client.name == "rust_analyzer" then
    bufmap("n", "<D-space>", vim.lsp.buf.hover, "Rust Hover")
    bufmap("n", "<Leader>a", vim.lsp.buf.code_action, "Rust Code Action")
  end
end

M.on_attach = on_attach

-- Use vim.lsp.config for custom server settings when supported
-- Fallback: for servers that need special settings, configure individually

-- Example: lua_ls with diagnostics globals
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "use", "on", "use_rocks" },
      },
      runtime = {
        version = "LuaJIT",
      },
    },
  },
})

-- You can repeat for other servers if you need ...
-- For "null" or simple ones, relying on automatic_enable may suffice

-- Example: solidity with custom cmd/root_dir
local util = lspconfig.util
vim.lsp.config("solidity", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetypes = { "solidity" },
  root_dir = util.find_git_ancestor,
  single_file_support = true,
})

-- For all other installed servers via mason that you didn't explicitly config, you can optionally hook them:
-- mason_lspconfig.setup({
--   ensure_installed = {...},
--   handlers = {
--     -- Default handler
--     function(server_name)
--       vim.lsp.config(server_name, {
--         on_attach = on_attach,
--         capabilities = capabilities,
--       })
--     end,
--     -- Override for specific ones if needed
--     -- ["html"] = function() ... end
--   }
-- })

-- Format on save example (attach when client has formatting capability)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if client and client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- Any other handlers/customization like signing diagnostic symbols, hover borders etc.
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
  return vim.lsp.handlers.hover(err, result, ctx, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
  return vim.lsp.handlers.signature_help(err, result, ctx, config)
end

return M
