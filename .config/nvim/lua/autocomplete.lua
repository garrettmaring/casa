-- autocomplete.lua
--
-- autocomplete uses nvim-cmp, nvim-lspconfig, snippets, and more to create a configurable and robust
-- completion solution
--
-- domain specific autocomplete tweaks should be kept in relevant config files (git.lue for the cmp-git completion filetype setup)

vim.opt.completeopt = {'menu', 'menuone', 'noselect', 'noinsert'}

local cmp = require('cmp') -- completion plugin
local luasnip = require('luasnip') -- how to expand snippet (completion)
local compare = require('cmp.config.compare')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  -- provide luasnip as expansion mechanism
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },

  -- ordered by priority data sources for completion menu
  sources = cmp.config.sources({
    {name = 'path'}, -- complete the filepath
    {name = 'copilot' }, -- github copilot
    {name = 'nvim_lsp' }, -- complete from language server
    {name = 'nvim_lsp_signature_help'}, -- better function signature completion
    {name = 'luasnip'}, -- friendly snippets
  }, {
    {name = 'fuzzy_buffer', keyword_length = 3 }, -- complete with other words in buffer
    {name = 'calc', keyword_length = 3}, -- eval math
    {name = 'crates', keyword_length = 4}, -- cargo crates
    {name = 'plugins', keyword_length = 4}, -- neovim plugins
    {name = 'npm', keyword_length = 4}, -- npm packages
  }),

  -- style completion UI
  window = {
    documentation = cmp.config.window.bordered()
  },

  -- format  completion items
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = '', --  LSP code completion
        luasnip = '', -- snippets
        fuzzy_buffer = '', -- words in buffer
        path = '', -- filepath
        copilot = '', -- github copilot
        calc = '',
        plugins = '', -- neovim plugins
        crates = '',
        npm = '',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },

	sorting = {
		priority_weight = 2,
		comparators = {
			require('cmp_fuzzy_buffer.compare'),
			compare.offset,
			compare.exact,
			compare.score,
			compare.recently_used,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		}
	},

  -- maps & motion
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),

    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Select,
      select = false -- do not select by default when hitting Enter
    }),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item { behavior = require "cmp.utils.api".is_cmdline_mode() and cmp.SelectBehavior.Insert or cmp.SelectBehavior.Select }
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },

  -- disable completion in certain scenarios such as when commenting or in Telescope's prompt UI
  enabled = function()
    local context = require 'cmp.config.context'
    local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
    local in_comment = context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment")

    if in_prompt or in_comment then
      return false
    else
      return true
    end
  end
})

-- add parentheses after selecting function
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- show autocompletion faster
--vim.api.nvim_create_autocmd(
  --{"TextChangedI", "TextChangedP"},
  --{
    --callback = function()
      --local line = vim.api.nvim_get_current_line()
      --local cursor = vim.api.nvim_win_get_cursor(0)[2]

      ---- TODO: respect enabled function

      --local current = string.sub(line, cursor, cursor + 1)
      --if current == "." or current == "," or current == " " then
        --require('cmp').close()
      --end

      --local before_line = string.sub(line, 1, cursor + 1)
      --local after_line = string.sub(line, cursor + 1, -1)
      --if not string.match(before_line, '^%s+$') then
        --if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
          --require('cmp').complete()
        --end
      --end
  --end,
  --pattern = "*"
--})

