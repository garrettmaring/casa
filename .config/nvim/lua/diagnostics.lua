local trouble = require('trouble')
local options = { silent = true, noremap = true }

trouble.setup({
  position = "bottom",
  height = 10,
  width = 50,
  mode = "workspace_diagnostics",
  group = true,
  padding = true,
  fold_open = "",
  fold_closed = "",
  indent_lines = true,
  auto_open = false,
  auto_close = false,
  auto_preview = true,
  auto_fold = false,
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = { "<cr>", "<tab>" },
    open_split = { "<c-x>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    jump_close = { "o" },
    toggle_mode = "m",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    close_folds = { "zM", "zm" },
    open_folds = { "zR", "zr" },
    toggle_fold = { "zA", "za" },
    previous = "k",
    next = "j"
  },
  icons = {
    --indent = {
    --fold = true, -- enable fold icons
    --open = "",
    --closed = ""
    --},
    diagnostic = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " "
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = "ﳠ ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " "
    }
  }
})

-- Key mappings
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>dw", "<cmd>Trouble workspace_diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>do", "<cmd>Trouble document_diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist toggle<cr>", options)
vim.keymap.set("n", "<leader>dq", "<cmd>Trouble quickfix toggle<cr>", options)
vim.keymap.set("n", "<leader>dr", "<cmd>Trouble lsp_references toggle<cr>", options)
