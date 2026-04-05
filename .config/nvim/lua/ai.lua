-- =======================
-- ai.lua (Consolidated)
-- =======================
--
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

--------------------------------------------------------------------------------
-- 1) Load Avante
--------------------------------------------------------------------------------
local has_avante_lib, avante_lib = pcall(require, "avante_lib")
if not has_avante_lib then
  return
end

avante_lib.load()

local has_avante, avante = pcall(require, "avante")
if not has_avante then
  return
end

-- By default Avante also has a mapping <leader>aa → :Avante, <leader>at → :AvanteToggle
map('n', '<leader>ac', ':AvanteToggle<cr>', options) -- no close

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
avante.setup({
  provider = "openai",
  cursor_applying_provider = 'groq',
  providers = {
    openai = {
      api_key_name = "OPENAI_API_KEY",
      --endpoint = "https://api.openai.com/v1",
      use_response_api = true,
      model = "gpt-5.4",
      extra_request_body = {
        temperature = 0,
        --max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
    },
    claude = {
      api_key_name = "ANTHROPIC_API_KEY",
      model = "claude-3-7-sonnet-latest",
      extra_request_body = {
        -- NON-THINKING TEMP:
        temperature = 0.000069,
      },
      --thinking = {
      --type = "enabled",
      ----budget_tokens = 6000 -- Allocate 64K tokens for reasoning
      --},
      --disabled_tools = { "git_commit" },
      --max_tokens = 64000, -- add for 3.7
    },
    gemini = {
      api_key_name = "GEMINI_API_KEY",
      --model = "gemini-2.0-pro-exp",
      model = "gemini-2.5-pro-exp-03-25",
      --model = 'gemini-2.0-flash-thinking-exp-01-21',
    },
    groq = { -- define groq provider
      api_key_name = "GROQ_API_KEY",
      endpoint = 'https://api.groq.com/openai/v1/',
      model = 'llama-3.3-70b-versatile',
      max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
    },
  },
  -- ui
  windows = {
    position = "left",
    width = 32, -- The Avante sidebar width
    input = {
      height = 13,
    }
  },
  -- Additional config as you wish...
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt =
    "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = true, -- default: false... hm not working?
    support_paste_from_clipboard = false,
    minimize_diff = true,                    -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true,            -- Whether to enable token counting. Default to true.
    enable_cursor_planning_mode = false,     -- Whether to enable Cursor Planning Mode. Default to false.
    --enable_claude_text_editor_tool_mode = true,
  },
})

do
  local ok, Sidebar = pcall(require, "avante.sidebar")
  if ok and not Sidebar._casa_tool_use_guarded then
    local original_render_tool_use_control_buttons = Sidebar.render_tool_use_control_buttons
    Sidebar.render_tool_use_control_buttons = function(self, ...)
      local result = self and self.containers and self.containers.result
      if not result or not result.winid or not result.bufnr then
        return
      end
      if not vim.api.nvim_win_is_valid(result.winid) or not vim.api.nvim_buf_is_valid(result.bufnr) then
        return
      end
      return original_render_tool_use_control_buttons(self, ...)
    end

    local original_get_current_tool_use_message_uuid = Sidebar.get_current_tool_use_message_uuid
    Sidebar.get_current_tool_use_message_uuid = function(self, ...)
      local result = self and self.containers and self.containers.result
      if not result or not result.winid then
        return nil
      end
      if not vim.api.nvim_win_is_valid(result.winid) then
        return nil
      end
      return original_get_current_tool_use_message_uuid(self, ...)
    end

    Sidebar._casa_tool_use_guarded = true
  end
end

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
