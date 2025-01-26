# treesitter-context.lua

Patch into treesitter-context.lua
(~/.local/share/nvim/site/pack/*/start/nvim-treesitter-context/lua/treesitter-context.lua).

Improve get_text_node function handling of types and errors.

```
...
local function get_text_for_node(node, bufnr)
  -- patched by me garrett the great. was getting errors on this call, resolved now
  --print("Debug: Node type:", node and node:type() or "nil")
  --print("Debug: Bufnr:", bufnr, "Type:", type(bufnr))
  --print("Debug: Node range:", node and { node:range() } or "nil")

  if not node then return "" end

  if type(bufnr) ~= "number" then
    --print("Debug: Invalid bufnr type, using current buffer")
    bufnr = vim.api.nvim_get_current_buf()
  end

  if not vim.api.nvim_buf_is_valid(bufnr) then
    --print("Debug: Invalid buffer:", bufnr)
    return ""
  end

  --print("Debug: Buffer content:", vim.inspect(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)))

  local text
  local ok, result = pcall(vim.treesitter.get_node_text, node, bufnr)
  if not ok or not result then
    --print("Debug: Falling back to vim.treesitter.query.get_node_text")
    ok, result = pcall(vim.treesitter.query.get_node_text, node, bufnr)
  end
  if not ok or not result then
    --print("Debug: Both get_node_text methods failed")
    return ""
  end
  text = result

  local type = get_type_pattern(node, config.patterns.default) or node:type()
  local filetype = vim.bo.filetype

  local skip_leading_type = (skip_leading_types[type] or {})[filetype]
  if skip_leading_type then
    local children = ts_utils.get_named_children(node)
    for _, child in ipairs(children) do
      if child:type() ~= skip_leading_type then
        node = child
        break
      end
    end
  end

  local start_row, start_col = node:start()
  local end_row, end_col     = node:end_()

  local lines                = vim.split(text, '\n')

  if start_col ~= 0 then
    local first_line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    if first_line then
      lines[1] = first_line
    end
  end
  start_col = 0

  local last_type = (last_types[type] or {})[filetype]

  local last_position

  if last_type then
    local child = find_node(node, last_type)

    if child then
      last_position = { child:end_() }

      end_row = last_position[1]
      end_col = last_position[2]
      local last_index = end_row - start_row
      lines = vim.list_slice(lines, 1, last_index + 1)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
  end

  if not last_position then
    lines = vim.list_slice(lines, 1, 1)
    end_row = start_row
    end_col = #lines[1]
  end

  local range = { start_row, start_col, end_row, end_col }

  return lines, range
end
...
```
