local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function get_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
end

local function is_blank(line)
  return line:match("^%s*$") ~= nil
end

local function indent_width(line)
  local indent = line:match("^%s*") or ""
  return #indent
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
    start_row = start_row,
    end_row = end_row,
  }
end

local function set_linewise_selection(start_row, end_row)
  vim.api.nvim_win_set_cursor(0, { start_row, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { end_row, 0 })
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

local function move_to_line(row)
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

function M.select_inner_code_block()
  select_code_block(false)
end

function M.select_around_code_block()
  select_code_block(true)
end

map({ "n", "x", "o" }, "]c", M.goto_next_code_block_start,
  vim.tbl_extend("force", opts, { desc = "Next code block start" }))
map({ "n", "x", "o" }, "[c", M.goto_previous_code_block_start,
  vim.tbl_extend("force", opts, { desc = "Previous code block start" }))
map({ "n", "x", "o" }, "]C", M.goto_next_code_block_end,
  vim.tbl_extend("force", opts, { desc = "Next code block end" }))
map({ "n", "x", "o" }, "[C", M.goto_previous_code_block_end,
  vim.tbl_extend("force", opts, { desc = "Previous code block end" }))
map({ "x", "o" }, "ic", M.select_inner_code_block,
  vim.tbl_extend("force", opts, { desc = "Inside code block" }))
map({ "x", "o" }, "ac", M.select_around_code_block,
  vim.tbl_extend("force", opts, { desc = "Around code block" }))

return M
