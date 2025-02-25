-- =======================
-- ai.lua (Consolidated)
-- =======================

--------------------------------------------------------------------------------
-- 1) Load Avante
--------------------------------------------------------------------------------
require("avante_lib").load()

-- By default Avante also has a mapping <leader>aa → :Avante, <leader>at → :AvanteToggle

--------------------------------------------------------------------------------
-- 2) Make Avante buffers modifiable if needed
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteSelectedFiles", "AvanteInput" },
  callback = function()
    vim.bo.modifiable = true
  end,
})

--------------------------------------------------------------------------------
-- 3) Avante setup
--------------------------------------------------------------------------------
require("avante").setup({
  provider = "claude",
  claude = {
    model = "claude-3-7-sonnet-latest",
    temperature = 0.000069,
    max_tokens = 64000,
  },
  -- If you use Gemini or others, you can specify them here:
  -- gemini = { ... },
  windows = {
    position = "left",
    width = 32, -- The Avante sidebar width
    input = {
      height = 13,
    }
  },
  -- Additional config as you wish...
})

--------------------------------------------------------------------------------
-- 4) After your Edge color scheme is set, optionally tweak floating highlights
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "edge",
  callback = function()
    -- If Avante uses "NuiSplit"/"NuiPopupBorder"/"AvanteChat" for floats/popup,
    -- these lines unify them. (Set bg, but leave fg = nil to preserve Edge text color.)
    local bg_color = "#373943"

    vim.cmd([[
      hi NuiSplit guibg=NONE ctermbg=NONE
      hi NuiPopupBorder guibg=NONE ctermbg=NONE
      hi AvanteChat guibg=NONE ctermbg=NONE
    ]])

    vim.api.nvim_set_hl(0, "NuiSplit", { bg = bg_color })
    vim.api.nvim_set_hl(0, "NuiPopupBorder", { bg = bg_color })
    vim.api.nvim_set_hl(0, "AvanteChat", { bg = bg_color })
  end,
})

--------------------------------------------------------------------------------
-- 5) Make a custom highlight group for Avante sidebars’ background:
--    We set ONLY 'bg', so text color remains from your Edge theme.
--------------------------------------------------------------------------------
vim.api.nvim_set_hl(0, "MyAvanteBg", { bg = "#373943" })

--------------------------------------------------------------------------------
-- 6) Combine FileType & BufWinEnter to ensure *all* Avante windows
--    (including "AvanteInput") actually get "MyAvanteBg".
--
--    Pattern includes:
--      - Avante (main chat)
--      - AvanteSelectedFiles (file‐select)
--      - AvanteInput (the text input)
--      - AvanteChat (popups)
--------------------------------------------------------------------------------
local function set_avante_winhl(bufnr)
  vim.schedule(function()
    local winid = vim.fn.bufwinid(bufnr)
    if winid ~= -1 then
      -- Override Normal/EndOfBuffer to get a uniform background
      vim.api.nvim_win_set_option(winid, "winhighlight", table.concat({
        "Normal:MyAvanteBg",
        "EndOfBuffer:MyAvanteBg",
        -- If you see any leftover highlights (SignColumn, CursorLine, etc.),
        -- you can add them here as well, e.g. "SignColumn:MyAvanteBg".
      }, ","))
    end
  end)
end

-- 6A) Using FileType
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteSelectedFiles", "AvanteInput", "AvanteChat" },
  callback = function(ctx)
    set_avante_winhl(ctx.buf)
  end,
})

-- 6B) Using BufWinEnter
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(ctx)
    local ft = vim.bo[ctx.buf].filetype
    if ft == "Avante" or ft == "AvanteSelectedFiles"
        or ft == "AvanteInput" or ft == "AvanteChat" then
      set_avante_winhl(ctx.buf)
    end
  end,
})

--------------------------------------------------------------------------------
-- 7) If Avante uses NormalFloat/FloatBorder for certain floating windows:
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "AvanteChat",
  callback = function(ctx)
    vim.schedule(function()
      local winid = vim.fn.bufwinid(ctx.buf)
      if winid ~= -1 then
        vim.api.nvim_win_set_option(winid, "winhighlight",
          "NormalFloat:MyAvanteBg,FloatBorder:MyAvanteBg"
        )
      end
    end)
  end,
})

--------------------------------------------------------------------------------
-- That’s it! Now AvanteInput, Avante, AvanteSelectedFiles, and AvanteChat
-- all share the #373943 background, leaving text color alone.
--------------------------------------------------------------------------------
