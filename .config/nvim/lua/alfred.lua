--[[
Behaviors:
- Reserves `<space>a` for a future Alfred/Cody-style AI launcher, but the active mapping is a no-op placeholder today.
- Leaves the named-chat mapping and `sg.nvim` setup commented out, so no Sourcegraph/Cody integration is currently active.
]]
vim.keymap.set("n", "<space>a", function()
  -- todo: ENGIIIIII
  --require("sg.cody.commands").toggle()
end)

--vim.keymap.set("n", "<space>an", function()
  --local name = vim.fn.input "chat name: "
  -- todo: doesn't load?
  --require("sg.cody.commands").chat(name)
--end)

--require("sg").setup {
  --on_attach = require("lsp").on_attach,
  -- FIX: topleft vnew for cody split
--}
