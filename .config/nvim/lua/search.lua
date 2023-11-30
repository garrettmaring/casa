-- searching for files, code, etc.
-- @see https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions#sorter

local builtin = require('telescope.builtin')

require('telescope').setup{
  pickers = {
    live_grep = {}
  },
  extensions = {
    fzf = { -- improve performance using native+simplified fzf
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
-- require("telescope").load_extension("refactoring")

----- maps
vim.keymap.set('n', '<leader>sf', builtin.find_files, {}) -- search files
vim.keymap.set('n', '<leader>ss', builtin.live_grep, {}) -- search source code
vim.keymap.set('n', '<leader>sb', builtin.buffers, {}) -- search buffers
vim.keymap.set('n', '<leader>st', builtin.help_tags, {}) -- search tags
-- todo: open live_grep with word object under cursor
-- vim.keymap.set('n', '<leader>sc', builtin.live_grep, {}) -- search under cursor source code
