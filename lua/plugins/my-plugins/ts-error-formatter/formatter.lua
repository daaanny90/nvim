local M = {}

function M.format_diagnostic(diagnostic)
  local formatted = string.format('[%s] %s', diagnostic.source, diagnostic.message)

  if diagnostic.code then
    formatted = string.format('%s (Error code: %s)', formatted, diagnostic.code)
  end

  if diagnostic.range and diagnostic.range.start then
    local line = diagnostic.range.start.line + 1
    local character = diagnostic.range.start.character + 1
    formatted = string.format('%s at line %d, col %d', formatted, line, character)
  end

  return formatted
end

return M
