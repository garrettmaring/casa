--[[
Behaviors:
- Exports `setup()` to switch folding to Tree-sitter expression mode with custom fold text/highlights and UFO integration.
- Disables fold UI inside `NvimTree` buffers via `FileType`.
- Maps `zR`, `zM`, `zr`, and `zm` to UFO open/close helpers.
]]
-- Refined fold configuration
local M = {}

-- Setup function to be called from init.lua
function M.setup()
  -- Set fold options globally
  vim.opt.foldcolumn = "1"                        -- Show a small fold column
  vim.opt.foldmethod = "expr"                     -- Use expression for folding
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
  vim.opt.foldlevel = 99                          -- Start with all folds open
  vim.opt.foldenable = true                       -- Enable folding

  -- Custom fold text function for a cleaner appearance
  vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]

  -- Subtle but visible fold styling
  vim.cmd([[
    highlight FoldColumn guifg=#5c6370 guibg=NONE
    highlight Folded guifg=#abb2bf guibg=#2c323c gui=italic
  ]])

  -- Ensure fold settings don't affect NvimTree
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "NvimTree",
    callback = function()
      vim.wo.foldcolumn = "0"
      vim.wo.foldenable = false
    end
  })

  -- Keymaps for easier fold navigation
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })
end

return M
