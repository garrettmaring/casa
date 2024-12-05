-- file tree
--
-- @see https://github.com/nvim-tree/nvim-tree.lua

local nvim_tree = require('nvim-tree')
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>ff', ':NvimTreeFindFile<cr>', options)
map('n', '<leader>fo', ':NvimTreeOpen<cr>', options)
map('n', '<leader>fc', ':NvimTreeClose<cr>', options)

-- FIX: open filetree when opening vim for the first time


-- TODO: close the filetree when exiting last vim buffer
-- only remaining buffers after closing a file are diagnostics and file tree, quit vim
--vim.api.nvim_command([[
--augroup CloseFileTreeWhenLeavingVim
--autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
--augroup END
--]])


-- disable ctrl-k showing more detailed file information (remap it) as it conflict with pane-window movement
local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end

  -- Load default mappings first
  api.config.mappings.default_on_attach(bufnr)

  -- Override the info/details mapping with your preferred key
  vim.keymap.set('n', '<Your-Key>', api.node.show_info_popup, opts('Info'))
  -- Remove the default Ctrl-K mapping
  vim.keymap.del('n', '<C-k>', { buffer = bufnr })
end

nvim_tree.setup({
  on_attach = my_on_attach,
  view = {
    side = "right"
  },

  renderer = {
    highlight_git = true,

    icons = {
      show = {
        folder_arrow = false,
        git = true,
      }
    }
  }
})
