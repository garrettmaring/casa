local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local augroup = vim.api.nvim_create_augroup("PagingIndicators", { clear = true })
local statuscolumn_expr = "%{%v:lua.require('paging').statuscolumn()%}"
local marker_column_width = 5
local render_state_by_win = {}

local ignored_filetypes = {
  NvimTree = true,
  Outline = true,
  Trouble = true,
}

local half_page_down = string.char(4) .. "zz"
local half_page_up = string.char(21) .. "zz"
local full_page_down = string.char(6) .. "zz"
local full_page_up = string.char(2) .. "zz"
local line_scroll_down = string.char(5)
local line_scroll_up = string.char(25)

local function get_win()
  return tonumber(vim.g.statusline_winid) or vim.api.nvim_get_current_win()
end

local function get_win_var(win, name)
  local ok, value = pcall(vim.api.nvim_win_get_var, win, name)
  if ok then
    return value
  end
  return nil
end

local function win_opt(win, name)
  return vim.api.nvim_get_option_value(name, { win = win })
end

local function window_edges(win)
  local ok, edges = pcall(vim.api.nvim_win_call, win, function()
    return {
      topline = vim.fn.line("w0"),
      botline = vim.fn.line("w$"),
    }
  end)

  if ok and edges then
    return edges.topline, edges.botline
  end

  local info = vim.fn.getwininfo(win)[1] or {}
  return info.topline or 1, info.botline or 1
end

local function plain_statuscolumn(buf)
  if ignored_filetypes[vim.bo[buf].filetype] then
    return true
  end

  return vim.bo[buf].buftype ~= ""
end

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
  if ok and hl then
    return hl
  end
  return {}
end

local function set_highlights()
  local info = get_hl("DiagnosticInfo")
  local warn = get_hl("DiagnosticWarn")
  local non_text = get_hl("NonText")
  local line_nr = get_hl("LineNr")

  vim.api.nvim_set_hl(0, "PagingDelimiter", {
    fg = non_text.fg or line_nr.fg,
    bg = line_nr.bg,
  })

  vim.api.nvim_set_hl(0, "PagingTarget", {
    fg = warn.fg or 0xE5C07B,
    bg = line_nr.bg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "PagingTargetLineNr", {
    fg = warn.fg or 0xE5C07B,
    bg = line_nr.bg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "PagingLast", {
    fg = info.fg or 0x61AFEF,
    bg = line_nr.bg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "PagingLastLineNr", {
    fg = info.fg or 0x61AFEF,
    bg = line_nr.bg,
    bold = true,
  })
end

local function project_line(line, top, bot)
  if not line then
    return nil, 0
  end

  if line < top then
    return top, top - line
  end

  if line > bot then
    return bot, line - bot
  end

  return line, 0
end

local function marker_label(symbol, distance)
  if not symbol then
    return nil
  end

  if distance > 0 then
    return symbol .. "+" .. distance
  end

  return symbol
end

local function target_label(symbol, offscreen, relative)
  if not symbol then
    return nil
  end

  if offscreen and relative > 0 then
    return symbol .. relative
  end

  return symbol
end

local function append_row_marker(row_markers, row, group, label)
  if not row or not label then
    return
  end

  row_markers[row] = row_markers[row] or {}
  table.insert(row_markers[row], {
    group = group,
    text = label,
  })
end

local function clear_last_context(win)
  pcall(vim.api.nvim_win_del_var, win, "paging_last_context")
end

local function synced_last_context(win, topline, botline)
  local last_context = get_win_var(win, "paging_last_context")
  if not last_context then
    return nil
  end

  if last_context.anchor_topline and (last_context.anchor_topline ~= topline or last_context.anchor_botline ~= botline) then
    clear_last_context(win)
    return nil
  end

  return last_context
end

local function build_render_state(win)
  if not vim.api.nvim_win_is_valid(win) then
    return nil
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if plain_statuscolumn(buf) then
    return {
      buf = buf,
      plain = true,
    }
  end

  local cursor = vim.api.nvim_win_get_cursor(win)[1]
  local line_count = vim.api.nvim_buf_line_count(buf)
  local height = vim.api.nvim_win_get_height(win)
  local scroll = win_opt(win, "scroll")
  local step = scroll > 0 and scroll or math.max(1, math.floor((height - 1) / 2))
  local topline, botline = window_edges(win)
  local target_up = math.max(1, cursor - step)
  local target_down = math.min(line_count, cursor + step)

  if target_up == cursor then
    target_up = nil
  end

  if target_down == cursor then
    target_down = nil
  end

  local up_row, up_distance = project_line(target_up, topline, botline)
  local down_row, down_distance = project_line(target_down, topline, botline)
  local up_relative = target_up and (cursor - target_up) or 0
  local down_relative = target_down and (target_down - cursor) or 0
  local last_context = synced_last_context(win, topline, botline)
  local last_edge_row, last_edge_distance = project_line(
    last_context and last_context.edge_line or nil,
    topline,
    botline
  )
  local last_cursor_row, last_cursor_distance = project_line(
    last_context and last_context.cursor_line or nil,
    topline,
    botline
  )

  local row_markers = {}
  append_row_marker(
    row_markers,
    up_row,
    "PagingTarget",
    target_label("↑", up_distance > 0, up_relative)
  )
  append_row_marker(
    row_markers,
    down_row,
    "PagingTarget",
    target_label("↓", down_distance > 0, down_relative)
  )
  append_row_marker(
    row_markers,
    last_edge_row,
    "PagingLast",
    marker_label(last_context and last_context.edge_symbol or nil, last_edge_distance)
  )
  append_row_marker(
    row_markers,
    last_cursor_row,
    "PagingLast",
    marker_label("C", last_cursor_distance)
  )

  local state = {
    buf = buf,
    cursor = cursor,
    topline = topline,
    botline = botline,
    line_count = line_count,
    marker_width = marker_column_width,
    target_up = target_up,
    target_down = target_down,
    up_row = up_row,
    down_row = down_row,
    last_edge_row = last_edge_row,
    last_cursor_row = last_cursor_row,
    row_markers = row_markers,
    target_rows = {},
    last_rows = {},
  }

  if up_row then
    state.target_rows[up_row] = true
  end

  if down_row then
    state.target_rows[down_row] = true
  end

  if last_edge_row then
    state.last_rows[last_edge_row] = true
  end

  if last_cursor_row then
    state.last_rows[last_cursor_row] = true
  end

  return state
end

local function delimiter_symbol(lnum, view)
  local is_top = lnum == view.topline
  local is_bottom = lnum == view.botline

  if is_top and is_bottom then
    return "┼"
  end

  if is_top then
    return "┬"
  end

  if is_bottom then
    return "┴"
  end

  return " "
end

local function fit_marker_text(text, width)
  if width <= 0 then
    return ""
  end

  if vim.fn.strdisplaywidth(text) <= width then
    return text
  end

  if width == 1 then
    return vim.fn.strcharpart(text, 0, 1)
  end

  return vim.fn.strcharpart(text, 0, width - 1) .. "+"
end

local function marker_segment(lnum, view)
  local out = {}
  local width = 0

  local delimiter = delimiter_symbol(lnum, view)
  if delimiter ~= " " then
    table.insert(out, "%#PagingDelimiter#")
    table.insert(out, delimiter)
    width = width + 1
  end

  for _, part in ipairs(view.row_markers[lnum] or {}) do
    local remaining = view.marker_width - width
    if remaining <= 0 then
      break
    end

    local text = fit_marker_text(part.text, remaining)
    if text ~= "" then
      table.insert(out, "%#" .. part.group .. "#")
      table.insert(out, text)
      width = width + vim.fn.strdisplaywidth(text)
    end
  end

  if width < view.marker_width then
    table.insert(out, "%*")
    table.insert(out, string.rep(" ", view.marker_width - width))
  end

  table.insert(out, "%*")
  return table.concat(out)
end

local function number_text(win, view)
  if not win_opt(win, "number") then
    return ""
  end

  local width = math.max(win_opt(win, "numberwidth"), #tostring(view.line_count))
  if vim.v.virtnum ~= 0 then
    return string.rep(" ", width)
  end

  local lnum = vim.v.lnum
  local relnum = vim.v.relnum
  local text = tostring(lnum)

  if win_opt(win, "relativenumber") and relnum ~= 0 then
    text = tostring(relnum)
  end

  return string.format("%" .. width .. "s", text)
end

local function number_hl(win, view)
  if vim.v.virtnum ~= 0 then
    return "LineNr"
  end

  local lnum = vim.v.lnum
  if view.target_rows[lnum] then
    return "PagingTargetLineNr"
  end

  if view.last_rows[lnum] then
    return "PagingLastLineNr"
  end

  local cursorline = win_opt(win, "cursorline")
  local cursorlineopt = win_opt(win, "cursorlineopt")
  if cursorline and lnum == view.cursor and cursorlineopt:find("number", 1, true) then
    return "CursorLineNr"
  end

  return "LineNr"
end

local function fallback_statuscolumn(win, view)
  return table.concat({
    "%C%s%=",
    "%#",
    number_hl(win, view),
    "#",
    number_text(win, view),
    "%* ",
  })
end

function M.statuscolumn()
  local win = get_win()
  local view = render_state_by_win[win]

  if not view then
    view = build_render_state(win)
    render_state_by_win[win] = view
  end

  if not view then
    return "%C%s%=%l "
  end

  if view.plain then
    return "%C%s%=%l "
  end

  if vim.v.virtnum < 0 then
    return fallback_statuscolumn(win, view)
  end

  return table.concat({
    "%C",
    marker_segment(vim.v.lnum, view),
    "%s%=",
    "%#",
    number_hl(win, view),
    "#",
    number_text(win, view),
    "%* ",
  })
end

local function update_render_state(win)
  if not vim.api.nvim_win_is_valid(win) then
    render_state_by_win[win] = nil
    return nil
  end

  local state = build_render_state(win)
  render_state_by_win[win] = state
  return state
end

local function update_all_render_states()
  local live_wins = {}

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    live_wins[win] = true
    update_render_state(win)
  end

  for win in pairs(render_state_by_win) do
    if not live_wins[win] then
      render_state_by_win[win] = nil
    end
  end
end

local function redraw_statuscolumn(win)
  local ok = pcall(vim.api.nvim__redraw, {
    win = win,
    cursor = true,
    flush = true,
    statuscolumn = true,
    valid = false,
  })

  if not ok then
    vim.cmd("redraw!")
  end
end

local function refresh_statuscolumn(win)
  if not update_render_state(win) then
    return
  end

  redraw_statuscolumn(win)
end

local function remember_page_context(direction)
  local win = vim.api.nvim_get_current_win()
  local view = render_state_by_win[win] or build_render_state(win)

  if not view or view.plain then
    local topline, botline = window_edges(win)
    view = {
      cursor = vim.api.nvim_win_get_cursor(win)[1],
      topline = topline,
      botline = botline,
    }
  else
    render_state_by_win[win] = view
  end
  return {
    cursor_line = view.cursor,
    edge_line = direction == "up" and view.topline or view.botline,
    edge_symbol = direction == "up" and "T" or "B",
  }, win
end

local function execute_paging(command, direction)
  local context, win = remember_page_context(direction)
  vim.cmd.normal({ bang = true, args = { command } })

  local topline, botline = window_edges(win)
  context.anchor_topline = topline
  context.anchor_botline = botline
  vim.api.nvim_win_set_var(win, "paging_last_context", context)
  refresh_statuscolumn(win)
end

local function execute_line_scroll(command)
  local win = vim.api.nvim_get_current_win()
  clear_last_context(win)
  vim.cmd.normal({ bang = true, args = { command } })
  refresh_statuscolumn(win)
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = set_highlights,
})

vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "CursorMoved",
  "CursorMovedI",
  "WinNew",
  "VimResized",
  "WinEnter",
  "WinScrolled",
}, {
  group = augroup,
  callback = function(args)
    if args.event == "BufWinEnter" or args.event == "WinEnter" or args.event == "WinNew" or args.event == "VimResized" then
      update_all_render_states()
      return
    end

    update_render_state(vim.api.nvim_get_current_win())
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(args)
    render_state_by_win[tonumber(args.match)] = nil
  end,
})

-- Keep the centered cursor line visible in the line-number column after paging.
-- `settings.lua` disables line numbers globally, so paging enables them here.
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.statuscolumn = statuscolumn_expr
update_render_state(vim.api.nvim_get_current_win())

-- Ergonomic paging motions on the home row.
-- `<D-...>` is the macOS Command key in UIs that forward it to Neovim.
map("n", "<D-j>", function()
  execute_paging(half_page_down, "down")
end, opts) -- half-page down
map("n", "<D-J>", function()
  execute_line_scroll(line_scroll_down)
end, opts) -- one-line scroll down
map("n", "<D-k>", function()
  execute_paging(half_page_up, "up")
end, opts) -- half-page up
map("n", "<D-K>", function()
  execute_line_scroll(line_scroll_up)
end, opts) -- one-line scroll up
map("n", "<D-f>", function()
  execute_paging(full_page_down, "down")
end, opts) -- full-page forward
map("n", "<D-b>", function()
  execute_paging(full_page_up, "up")
end, opts) -- full-page backward

-- `<M-...>` remains the terminal-friendly Option/Alt fallback.
map("n", "<M-j>", function()
  execute_paging(half_page_down, "down")
end, opts) -- half-page down
map("n", "<M-J>", function()
  execute_line_scroll(line_scroll_down)
end, opts) -- one-line scroll down
map("n", "<M-k>", function()
  execute_paging(half_page_up, "up")
end, opts) -- half-page up
map("n", "<M-K>", function()
  execute_line_scroll(line_scroll_up)
end, opts) -- one-line scroll up
map("n", "<M-f>", function()
  execute_paging(full_page_down, "down")
end, opts) -- full-page forward
map("n", "<M-b>", function()
  execute_paging(full_page_up, "up")
end, opts) -- full-page backward

-- Keep hardware paging keys centered as well.
map("n", "<PageDown>", function()
  execute_paging(full_page_down, "down")
end, opts)
map("n", "<PageUp>", function()
  execute_paging(full_page_up, "up")
end, opts)

return M
