local M = {}

-- Funzione per formattare e aggiungere highlights per il grassetto e blocchi di codice
local function format_diagnostic(diagnostics)
  local formatted_lines = {}

  -- Funzione ausiliaria per identificare blocchi di codice
  local function highlight_code_blocks(message)
    if type(message) ~= 'string' then
      message = tostring(message)
    end

    local parts = {}
    local pattern = "()([`'{].-[}`'])()"
    local last_pos = 1

    for start_pos, block, end_pos in message:gmatch(pattern) do
      start_pos = tonumber(start_pos)
      end_pos = tonumber(end_pos)

      if start_pos and last_pos < start_pos then
        table.insert(parts, { message:sub(last_pos, start_pos - 1), 'Normal' })
      end
      if block then
        table.insert(parts, { block, 'CodeBlock' })
      end
      if end_pos then
        last_pos = end_pos
      end
    end

    if last_pos <= #message then
      table.insert(parts, { message:sub(last_pos), 'Normal' })
    end

    return parts
  end

  -- Loop attraverso tutti i diagnostics disponibili
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(formatted_lines, { '**Source**: ' .. diagnostic.source, 'Title' })

    if diagnostic.code then
      table.insert(formatted_lines, { 'Error Code: `' .. diagnostic.code .. '`', 'CodeBlock' })
    end

    -- Processa e formatta il messaggio diagnostico
    local diagnostic_message = diagnostic.message
    local message_parts = highlight_code_blocks(diagnostic_message)

    for _, part in ipairs(message_parts) do
      -- Se è un blocco di codice, spezzalo in una nuova riga
      if part[2] == 'CodeBlock' then
        table.insert(formatted_lines, { '', 'Normal' }) -- Aggiungi una linea vuota prima del blocco
        table.insert(formatted_lines, { part[1], 'CodeBlock' })
        table.insert(formatted_lines, { '', 'Normal' }) -- Aggiungi una linea vuota dopo il blocco
      else
        table.insert(formatted_lines, { part[1], 'Normal' })
      end
    end

    if diagnostic.range and diagnostic.range.start then
      local line = diagnostic.range.start.line + 1
      local character = diagnostic.range.start.character + 1
      table.insert(formatted_lines, { string.format('**Location**: Line %d, Column %d', line, character), 'Normal' })
    end

    -- Aggiungi una linea vuota tra errori se ci sono più diagnostics
    table.insert(formatted_lines, { '', 'Normal' })
  end

  return formatted_lines
end

-- Funzione per ridimensionare la finestra in base al contenuto
local function calculate_window_size(formatted)
  local width, height = 0, #formatted
  for _, line_info in ipairs(formatted) do
    local line_length = #line_info[1]
    if line_length > width then
      width = line_length
    end
  end
  return math.min(width + 4, 80), math.min(height + 2, 20) -- Limita la dimensione massima della finestra
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

  local formatted = format_diagnostic(diagnostics)

  if not formatted or #formatted == 0 then
    vim.notify('No diagnostics available', vim.log.levels.INFO)
    return
  end

  local width, height = calculate_window_size(formatted)

  -- Crea la finestra fluttuante
  local opts_float = {
    relative = 'cursor',
    width = width,
    height = height,
    row = 1,
    col = 1,
    style = 'minimal',
    border = 'rounded',
  }

  -- Crea il buffer e setta la finestra
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, opts_float)

  -- Aggiusta il contenuto del buffer per ogni linea
  local line_count = 0
  for _, line_info in ipairs(formatted) do
    local line_content = line_info[1]
    local highlight_group = line_info[2]

    -- Spezza il contenuto per linee separate se contiene newline
    local lines = vim.split(line_content, '\n', true) -- true rimuove newline

    for _, line in ipairs(lines) do
      vim.api.nvim_buf_set_lines(buf, line_count, line_count + 1, false, { line })
      vim.api.nvim_buf_add_highlight(buf, -1, highlight_group, line_count, 0, -1)
      line_count = line_count + 1
    end
  end

  -- Chiudi la finestra quando il cursore si muove
  close_on_cursor_move(win)
end

-- Configurazione per gli highlights
function M.setup()
  vim.cmd 'highlight Title guifg=Yellow guibg=NONE gui=bold'
  vim.cmd 'highlight CodeBlock guifg=LightBlue guibg=NONE'
  print 'ts-error-formatter setup complete'
end

return M
