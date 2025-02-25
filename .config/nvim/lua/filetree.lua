-- TODO: when nvim tree opens a file (say with the smart renaming), that inner editor portion get's the gray background of nvim mistakenly

local nvim_tree = require('nvim-tree')
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>ff', ':NvimTreeFindFile<cr>', options)
map('n', '<leader>fo', ':NvimTreeOpen<cr>', options)
map('n', '<leader>fc', ':NvimTreeClose<cr>', options)

-- Function to calculate width (20% of window width for more space)
local function get_tree_width()
  return math.ceil(vim.o.columns * (20 / 100))
end

if not vim.treesitter.get_node_text then
  vim.treesitter.get_node_text = vim.treesitter.query.get_node_text
end

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

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<Your-Key>', api.node.show_info_popup, opts('Info'))
  vim.keymap.del('n', '<C-k>', { buffer = bufnr })

  -- Disable line numbers for this buffer
  vim.api.nvim_buf_call(bufnr, function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end)
end

-- Function to set NvimTree background color and padding
local function set_nvim_tree_highlights()
  vim.cmd("highlight NvimTreeNormal guibg=#373943")
  vim.cmd("highlight NvimTreeEndOfBuffer guibg=#373943")
  vim.cmd("highlight NvimTreeVertSplit guibg=#373943")
  vim.cmd("highlight NvimTreeIndentMarker guifg=#73797e guibg=#373943")
  vim.cmd("highlight NvimTreeRootFolder guibg=#373943")
  -- Add a custom highlight for left padding
  vim.cmd("highlight NvimTreeLeftPadding guibg=#373943")
end

nvim_tree.setup({
  on_attach = my_on_attach,
  view = {
    side = "right",
    width = get_tree_width(),
    float = {
      enable = false,
      quit_on_focus_loss = true,
    },
    number = false,
    relativenumber = false,
    signcolumn = "no",
  },
  renderer = {
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = false,
        git = true,
      },
      padding =
      " "             -- creating this extra space makes it a bit more verticallys scannable exactly what files i'm touching right now
    },
    indent_width = 2, -- Increase indent width for more left padding
  }
})

-- Apply custom styling to NvimTree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"

    -- Add left padding using winhl
    vim.wo.winhl = "Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer,SignColumn:NvimTreeLeftPadding"

    set_nvim_tree_highlights()
  end
})

-- Apply highlights after ColorScheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_nvim_tree_highlights
})

-- Apply highlights immediately
set_nvim_tree_highlights()
