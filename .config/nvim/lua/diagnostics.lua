-- need to learn this code more, was generate from deep research on good trouble config

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
    kinds = { -- what is all this...
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

-- Function to copy current file diagnostics to clipboard
local function copy_file_diagnostics()
  local diagnostics = vim.diagnostic.get(0) -- 0 means current buffer
  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    return
  end

  -- Sort diagnostics by line and column
  table.sort(diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  -- Convert severity numbers to readable text
  local severity_map = {
    [1] = "Error",
    [2] = "Warning",
    [3] = "Info",
    [4] = "Hint"
  }

  -- Format each diagnostic
  local lines = {
    string.format("Diagnostics for %s:", vim.fn.expand("%:p")),
    string.format("Total: %d", #diagnostics),
    "---"
  }

  for _, d in ipairs(diagnostics) do
    local line = string.format(
      "[%s] Line %d:%d - %s",
      severity_map[d.severity] or "Unknown",
      d.lnum + 1,
      d.col + 1,
      d.message:gsub("\n", " ")
    )
    table.insert(lines, line)
  end

  -- Copy to clipboard
  vim.fn.setreg('+', table.concat(lines, '\n'))
  vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
end

-- Key mappings
vim.keymap.set("n", "<leader>dy", copy_file_diagnostics,
  { desc = "Copy file diagnostics to clipboard", silent = true, noremap = true })
vim.keymap.set("n", "<leader>dc", "<cmd>Trouble close<cr>", options)
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>dw", "<cmd>Trouble workspace_diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>do", "<cmd>Trouble document_diagnostics toggle<cr>", options)
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist toggle<cr>", options)
vim.keymap.set("n", "<leader>df", "<cmd>Trouble quickfix toggle<cr>", options)
vim.keymap.set("n", "<leader>dr", "<cmd>Trouble lsp_references toggle<cr>", options)
