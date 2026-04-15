--[[
Behaviors:
- Defines custom indentation-based code-block motions and text objects.
- Supports linewise and blockwise selections, including blank-line-aware "around" ranges and blockwise column preservation through temporary `virtualedit=block`.
- Maps code-block motions in normal, visual, and operator-pending mode:
  `]c`/`<D-]>` next start, `[c`/`<D-[>` previous start, `]C`/`<D-}>` next end,
  `[C`/`<D-{>` previous end, `<D-(>` current start, and `<D-)>` current end.
- Maps visual/operator text objects: `ic` and `ac` for linewise selections,
  plus `iC` and `aC` for blockwise column-preserving selections.
]]
local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local CTRL_V = "\022"

local function get_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
end

local function is_blank(line)
  return line:match("^%s*$") ~= nil
end

local function indent_width(line)
  local indent = line:match("^%s*") or ""
  return vim.fn.strdisplaywidth(indent)
end

local function content_width(line)
  local trimmed = line:gsub("%s+$", "")
  return vim.fn.strdisplaywidth(trimmed)
end

local function mode_has_blockwise(mode)
  return mode:find(CTRL_V, 1, true) ~= nil
end

local function nearest_code_line(bufnr, row)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return nil
  end

  local current = get_line(bufnr, row)
  if not is_blank(current) then
    return row
  end

  for offset = 1, line_count do
    local down = row + offset
    if down <= line_count and not is_blank(get_line(bufnr, down)) then
      return down
    end

    local up = row - offset
    if up >= 1 and not is_blank(get_line(bufnr, up)) then
      return up
    end
  end

  return nil
end

local function code_block_range(bufnr, row)
  local anchor = nearest_code_line(bufnr, row)
  if not anchor then
    return nil
  end

  local anchor_indent = indent_width(get_line(bufnr, anchor))
  local start_row = anchor
  local end_row = anchor
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  for scan = anchor - 1, 1, -1 do
    local line = get_line(bufnr, scan)
    if is_blank(line) or indent_width(line) < anchor_indent then
      break
    end
    start_row = scan
  end

  for scan = anchor + 1, line_count do
    local line = get_line(bufnr, scan)
    if is_blank(line) or indent_width(line) < anchor_indent then
      break
    end
    end_row = scan
  end

  return {
    anchor = anchor,
    indent = anchor_indent,
    start_row = start_row,
    end_row = end_row,
  }
end

local function around_code_block_range(bufnr, row)
  local range = code_block_range(bufnr, row)
  if not range then
    return nil
  end

  local start_row = range.start_row
  local end_row = range.end_row
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  while start_row > 1 and is_blank(get_line(bufnr, start_row - 1)) do
    start_row = start_row - 1
  end

  while end_row < line_count and is_blank(get_line(bufnr, end_row + 1)) do
    end_row = end_row + 1
  end

  return {
    anchor = range.anchor,
    indent = range.indent,
    start_row = start_row,
    end_row = end_row,
  }
end

local function with_block_virtualedit(fn)
  local original = vim.wo.virtualedit
  if not original:find("block", 1, true) and not original:find("all", 1, true) then
    vim.wo.virtualedit = original == "" and "block" or (original .. ",block")
  end

  local ok, result = pcall(fn)
  vim.wo.virtualedit = original

  if not ok then
    error(result)
  end

  return result
end

local function move_to_display_column(row, col)
  local line = get_line(0, row)
  local target = math.max(col, 0)
  local display = 0
  local byte_col = #line
  local coladd = 0
  local tabstop = vim.bo.tabstop
  local char_count = vim.fn.strchars(line)

  if target == 0 then
    local view = vim.fn.winsaveview()
    view.lnum = row
    view.col = 0
    view.coladd = 0
    view.curswant = 1
    vim.fn.winrestview(view)
    return
  end

  for char_index = 0, char_count - 1 do
    local char = vim.fn.strcharpart(line, char_index, 1)
    local width = char == "\t" and (tabstop - (display % tabstop)) or vim.fn.strdisplaywidth(char)
    local next_byte = vim.str_byteindex(line, char_index + 1)

    if target < (display + width) then
      byte_col = vim.str_byteindex(line, char_index)
      coladd = target - display
      break
    end

    display = display + width
    byte_col = next_byte
  end

  if target > display then
    coladd = target - display
  end

  local view = vim.fn.winsaveview()
  view.lnum = row
  view.col = byte_col
  view.coladd = coladd
  view.curswant = target + 1
  vim.fn.winrestview(view)
end

local function set_linewise_selection(start_row, end_row)
  vim.api.nvim_win_set_cursor(0, { start_row, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { end_row, 0 })
end

local function set_blockwise_selection(start_row, end_row, left_col, right_col)
  with_block_virtualedit(function()
    move_to_display_column(start_row, left_col)
    vim.cmd("normal! " .. CTRL_V)
    move_to_display_column(end_row, right_col)
  end)
end

local function select_code_block(around)
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local range = around and around_code_block_range(bufnr, row) or code_block_range(bufnr, row)

  if not range then
    return
  end

  set_linewise_selection(range.start_row, range.end_row)
end

local function blockwise_code_block_range(bufnr, row, around)
  local range = around and around_code_block_range(bufnr, row) or code_block_range(bufnr, row)
  if not range then
    return nil
  end

  local right_edge = range.indent
  for scan = range.start_row, range.end_row do
    right_edge = math.max(right_edge, content_width(get_line(bufnr, scan)))
  end

  return {
    start_row = range.start_row,
    end_row = range.end_row,
    left_col = range.indent,
    right_col = math.max(right_edge, range.indent + 1) - 1,
  }
end

local function select_blockwise_code_block(around)
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local range = blockwise_code_block_range(bufnr, row, around)

  if not range then
    return
  end

  set_blockwise_selection(range.start_row, range.end_row, range.left_col, range.right_col)
end

local function move_to_line(row)
  if mode_has_blockwise(vim.fn.mode(1)) then
    with_block_virtualedit(function()
      move_to_display_column(row, vim.fn.virtcol(".") - 1)
    end)
    return
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd("normal! ^")
end

local function next_code_block_start(bufnr, row)
  local current = around_code_block_range(bufnr, row)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local scan = current and (current.end_row + 1) or row + 1

  while scan <= line_count do
    local line = get_line(bufnr, scan)
    if not is_blank(line) then
      local range = code_block_range(bufnr, scan)
      return range and range.start_row or scan
    end
    scan = scan + 1
  end
end

local function previous_code_block_start(bufnr, row)
  local current = around_code_block_range(bufnr, row)
  local scan = current and (current.start_row - 1) or row - 1

  while scan >= 1 do
    local line = get_line(bufnr, scan)
    if not is_blank(line) then
      local range = code_block_range(bufnr, scan)
      return range and range.start_row or scan
    end
    scan = scan - 1
  end
end

local function next_code_block_end(bufnr, row)
  local start_row = next_code_block_start(bufnr, row)
  if not start_row then
    return nil
  end

  local range = around_code_block_range(bufnr, start_row)
  return range and range.end_row or start_row
end

local function previous_code_block_end(bufnr, row)
  local start_row = previous_code_block_start(bufnr, row)
  if not start_row then
    return nil
  end

  local range = around_code_block_range(bufnr, start_row)
  return range and range.end_row or start_row
end

local function current_code_block_start(bufnr, row)
  local range = code_block_range(bufnr, row)
  return range and range.start_row or nil
end

local function current_code_block_end(bufnr, row)
  local range = code_block_range(bufnr, row)
  return range and range.end_row or nil
end

function M.goto_next_code_block_start()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = next_code_block_start(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.goto_previous_code_block_start()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = previous_code_block_start(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.goto_next_code_block_end()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = next_code_block_end(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.goto_previous_code_block_end()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = previous_code_block_end(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.goto_current_code_block_start()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = current_code_block_start(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.goto_current_code_block_end()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target = current_code_block_end(bufnr, row)

  if target then
    move_to_line(target)
  end
end

function M.select_inner_code_block()
  select_code_block(false)
end

function M.select_around_code_block()
  select_code_block(true)
end

function M.select_inner_blockwise_code_block()
  select_blockwise_code_block(false)
end

function M.select_around_blockwise_code_block()
  select_blockwise_code_block(true)
end

local motion_modes = { "n", "x", "o" }

local function map_motion_aliases(lhs_list, rhs, desc)
  for _, lhs in ipairs(lhs_list) do
    map(motion_modes, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end
end

map_motion_aliases({ "]c", "<D-]>" }, M.goto_next_code_block_start, "Next code block start")
map_motion_aliases({ "[c", "<D-[>" }, M.goto_previous_code_block_start, "Previous code block start")
map_motion_aliases({ "]C", "<D-}>" }, M.goto_next_code_block_end, "Next code block end")
map_motion_aliases({ "[C", "<D-{>" }, M.goto_previous_code_block_end, "Previous code block end")
map_motion_aliases({ "<D-)>" }, M.goto_current_code_block_end, "Current code block end")
map_motion_aliases({ "<D-(>" }, M.goto_current_code_block_start, "Current code block start")
map({ "x", "o" }, "ic", M.select_inner_code_block,
  vim.tbl_extend("force", opts, { desc = "Inside code block" }))
map({ "x", "o" }, "ac", M.select_around_code_block,
  vim.tbl_extend("force", opts, { desc = "Around code block" }))
map({ "x", "o" }, "iC", M.select_inner_blockwise_code_block,
  vim.tbl_extend("force", opts, { desc = "Inside code block (blockwise)" }))
map({ "x", "o" }, "aC", M.select_around_blockwise_code_block,
  vim.tbl_extend("force", opts, { desc = "Around code block (blockwise)" }))

return M
