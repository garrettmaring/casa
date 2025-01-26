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

# hologram

Patch ~/.local/share/nvim/site/pack/packer/start/hologram.nvim/lua/hologram/init.lua to avoid some error.

```lua
function hologram.buf_render_images(buf, top, bot)
  -- Check if the buffer is valid
  if not vim.api.nvim_buf_is_valid(buf) then
    --print("Hologram: Invalid buffer id: " .. tostring(buf))
    return
  end

  -- Use pcall to catch any errors when getting extmarks
  local ok, exts = pcall(vim.api.nvim_buf_get_extmarks, buf,
    vim.g.hologram_extmark_ns,
    { math.max(top - 1, 0), 0 },
    { bot - 2, -1 },
    {}
  )

  if not ok then
    --print("Hologram: Error getting extmarks: " .. tostring(exts))
    return
  end

  local curr_ids = {}
  for _, ext in ipairs(exts) do
    local id, row, col = unpack(ext)
    if Image.instances[id] then
      Image.instances[id]:display(row + 1, 0, buf, {})
      curr_ids[#curr_ids + 1] = id
    end
  end

  if prev_ids[buf] ~= nil then
    for _, id in ipairs(prev_ids[buf]) do
      if not vim.tbl_contains(curr_ids, id) and Image.instances[id] then
        Image.instances[id]:delete(buf, {})
      end
    end
  end
  prev_ids[buf] = curr_ids
end
```

Error I think was reproducible when creating a new file in treesitter filetree and then entering into it.

```error message
Error executing vim.schedule lua callback: ...te/pack/packer/start/hologram.nvim/lua/hologram/init.lua:47: Invalid buffer
id: 46

stack traceback:

[C]: in function 'nvim_buf_get_extmarks'

...te/pack/packer/start/hologram.nvim/lua/hologram/init.lua:47: in function 'buf_render_images'

...te/pack/packer/start/hologram.nvim/lua/hologram/init.lua:17: in function <...te/pack/packer/start/hologram.nvim
/lua/hologram/init.lua:17>
```
