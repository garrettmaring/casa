local ok, treesitter = pcall(require, 'nvim-treesitter')
if not ok then
  return
end

treesitter.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
