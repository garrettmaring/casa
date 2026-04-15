--[[
Behaviors:
- Loads `rust-tools.nvim` only when available and skips setup entirely on Neovim 0.11+.
- Adds buffer-local Rust mappings for `<D-space>` hover actions and `<Leader>a` code-action groups during attach, and warns instead of crashing if setup fails.
]]
-- rust-tools plugin configuration
--
-- @see https://github.com/simrat39/rust-tools.nvim

local ok, rt = pcall(require, "rust-tools")
if not ok then
  return
end

if vim.fn.has("nvim-0.11") == 1 then
  return
end

local setup_ok, err = pcall(rt.setup, {
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<D-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

if not setup_ok then
  vim.schedule(function()
    vim.notify(("Skipping rust-tools setup: %s"):format(err), vim.log.levels.WARN)
  end)
end
