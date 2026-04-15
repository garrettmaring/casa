--[[
Behaviors:
- Configures Telescope to include hidden files in `find_files` and `live_grep` while skipping `.git` and `.next`, then loads the native `fzf` sorter extension.
- Maps `<leader>sf`, `<leader>sc`, `<leader>sb`, and `<leader>st` to file search, live grep, buffer search, and help tags.
]]
-- searching for files, code, etc.
-- @see https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions#sorter

local map = vim.keymap.set
local builtin = require('telescope.builtin')

require('telescope').setup({
  defaults = {
    vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-g', '!{.git, .next}' },
    layout_config = {
      height = 0.70,
      --preview_width = 0.65, (TODO: ideally, this can be enabled for *certain* telescopes. but it was breaking plugins that use telescrope like avante as an 'unsupported feature for center layout strategy' (in avantes case)
      --prompt_position = 'top'
    }
  },
  pickers = {
    live_grep = {
      hidden = true
    },
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!{.git, .next}' },
    },
    buffers = {
      show_all_buffers = true,
    },
  },
  extensions = {
    fzf = {                           -- improve performance using native+simplified fzf
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
})

require('telescope').load_extension('fzf')
--require("telescope").load_extension("refactoring")

map('n', '<leader>sf', builtin.find_files, {}) -- search files
map('n', '<leader>sc', builtin.live_grep, {})  -- search code
map('n', '<leader>sb', builtin.buffers, {})    -- search buffers
map('n', '<leader>st', builtin.help_tags, {})  -- search tags

-- search hidden: (think default searches uzzy and files etc incl now) map('n', '<leader>sh',
--"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
--{ noremap = true })
-- todo: open live_grep with word object under cursor
-- vim.keymap.set('n', '<leader>sc', builtin.live_grep, {}) -- search under cursor source code
