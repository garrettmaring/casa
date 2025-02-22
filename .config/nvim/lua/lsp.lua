local LSP = {}

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local configs = require 'lspconfig.configs'

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- shared language setup config attach
function LSP.on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr) -- navic shows symbols in winbar
  end
end

-- lua language server config
lspconfig.lua_ls.setup({
  single_file_support = true,
  on_attach = LSP.on_attach, -- attach navic
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'use', 'vim', 'use_rocks', 'on' } -- define global namespaced keywords
      }
    }
  }
})

--require("typescript").setup({
--disable_commands = false,    -- prevent the plugin from creating Vim commands
--debug = false,               -- enable debug logging for commands
--go_to_source_definition = {
--fallback = true,           -- fall back to standard LSP definition on failure
--},
--server = {                   -- pass options to lspconfig's setup method
--on_attach = LSP.on_attach, -- attach navic
--},
--})
-- html language server config
lspconfig.html.setup({})
-- css language server config
lspconfig.cssls.setup({})
-- python language server config
lspconfig.pyright.setup({})
-- rust language server config
lspconfig.rust_analyzer.setup({})
-- tailwind
lspconfig.tailwindcss.setup({})
-- c sharp c#
lspconfig.csharp_ls.setup({})
-- typescript
lspconfig.ts_ls.setup({})
-- solidity/solang language server config
--lspconfig.solang.setup({})
-- solidity

configs.solidity = {
  default_config = {
    cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = lspconfig.util.find_git_ancestor,
    single_file_support = true,
  },
}

lspconfig.solidity.setup {}

-- add mappings when lsp attaches
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufmap = function(mode, lhs, rhs)
      local opts = { buffer = true }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- word highlight
    bufmap('n', '<leader>wh', '<cmd>lua vim.lsp.buf.hover()<cr>')
    -- word definition
    bufmap('n', '<leader>wd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    -- word references
    bufmap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    --bufmap('n', 'ss', '<cmd>lua vim.lsp.buf.signature_help()<cr>') -- show signature

    -- TODO: move this to _refactor
    -- <l>rc: refactor [under] cursor
    -- Renames all references to the symbol under the cursor
    bufmap('n', '<leader>rc', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Show diagnostics errors in a floating window
    -- WARNING: this mapping conflicts with normal e (end of word motion)
    -- bufmap('n', 'ew', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', '<C-e>', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
  -- This is where we attach the autoformatting for reasonable clients
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = args.buf

    if not client.server_capabilities.documentFormattingProvider then
      return
    end
  end,
})

-- format on buffer write
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = buffer,
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

--vim.api.nvim_create_autocmd('BufWritePre', {
--group = get_augroup(client),
--buffer = bufnr,
--callback = function()
--if not format_is_enabled then
--return
--end
--vim.lsp.buf.format {
--async = false,
--filter = function(c)
--return c.id == client.id
--end,
--}
--end,
--})

-- style the LSP UI
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

return LSP
