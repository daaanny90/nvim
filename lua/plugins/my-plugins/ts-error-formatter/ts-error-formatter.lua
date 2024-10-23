local M = {}

local function format_diagnostic(diagnostics)
  local formatted_lines = {}

  local function highlight_code_blocks(message)
    if type(message) ~= 'string' then
      message = tostring(message)
    end

    local parts = {}
    local pattern = "([^']*)('[^']*')"
    local last_pos = 1

    for normal_text, code_block in message:gmatch(pattern) do
      if #normal_text > 0 then
        table.insert(parts, { normal_text, 'Normal' })
      end

      if code_block then
        -- Rimuovi i delimitatori e applica l'indentazione
        local indented_code = '  ' .. code_block:gsub('\n', '\n  ')
        table.insert(parts, { indented_code, 'CodeBlock' })
      end

      -- Aggiorna la posizione finale
      last_pos = last_pos + #normal_text + #code_block
    end

    -- Aggiungi eventuali testo rimanente alla fine
    if last_pos <= #message then
      table.insert(parts, { message:sub(last_pos), 'Normal' })
    end

    return parts
  end

  for _, diagnostic in ipairs(diagnostics) do
    table.insert(formatted_lines, { diagnostic.source, 'Title' })

    if diagnostic.code then
      table.insert(formatted_lines, { 'Error Code: ' .. diagnostic.code, 'ErrorCode' })
    end

    local message_parts = highlight_code_blocks(diagnostic.message)

    print(vim.inspect(message_parts))

    for _, part in ipairs(message_parts) do
      if part[2] == 'CodeBlock' then
        -- table.insert(formatted_lines, { '', 'Normal' }) -- Linea vuota prima del codice
        for _, line in ipairs(vim.split(part[1], '\n')) do
          table.insert(formatted_lines, { line, 'CodeBlock' })
        end
      else
        table.insert(formatted_lines, part)
      end
    end

    if diagnostic.range and diagnostic.range.start then
      local line = diagnostic.range.start.line + 1
      local character = diagnostic.range.start.character + 1
      table.insert(formatted_lines, { string.format('**Location**: Line %d, Column %d', line, character), 'Location' })
    end

    table.insert(formatted_lines, { '', 'Normal' }) -- Separatore tra diagnostici
  end

  return formatted_lines
end

local function calculate_window_size(formatted)
  local max_width = 0
  local height = #formatted

  for _, line_info in ipairs(formatted) do
    local line_length = vim.fn.strdisplaywidth(line_info[1])
    if line_length > max_width then
      max_width = line_length
    end
  end
  max_width = max_width + 4
  height = height + 2

  -- Limita le dimensioni della finestra
  return math.min(max_width, 120), math.min(height, 30)
end

-- Funzione per chiudere la finestra fluttuante al movimento del cursore
local function close_on_cursor_move(win)
  vim.api.nvim_create_autocmd('CursorMoved', {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end

function M.open_formatted_float(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  print(vim.inspect(diagnostics))

  local formatted = format_diagnostic(diagnostics)

  if not formatted or #formatted == 0 then
    vim.notify('No diagnostics available', vim.log.levels.INFO)
    return
  end

  local width, height = calculate_window_size(formatted)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'cursor',
    width = width,
    height = height,
    row = 1,
    col = 1,
    style = 'minimal',
    border = 'rounded',
  })

  -- Iniziamo con una linea vuota per il margine superiore
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { '' })

  local current_line = 1

  for _, line_info in ipairs(formatted) do
    local lines = vim.split(line_info[1], '\n')

    for _, line in ipairs(lines) do
      vim.api.nvim_buf_set_lines(buf, current_line - 1, current_line, false, { line })
      vim.api.nvim_buf_add_highlight(buf, -1, line_info[2], current_line - 1, 0, -1)
      current_line = current_line + 1
    end
  end

  close_on_cursor_move(win)
end

function M.setup()
  vim.cmd [[
    highlight Title guifg=#FFD700 guibg=NONE gui=bold
    highlight ErrorCode guifg=#FF6347 guibg=NONE gui=italic
    highlight CodeBlock guifg=#87CEFA guibg=#1C1C1C gui=NONE
    highlight Location guifg=#98FB98 guibg=NONE gui=NONE
  ]]
  print 'ts-error-formatter setup complete'
end

return M
