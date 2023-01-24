-- TODO
vim.api.nvim_command([[
  augroup CloseFileTreeWhenLeavingVim
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END
]])

