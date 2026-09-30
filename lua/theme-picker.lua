-- ============================================================================
-- Theme picker — floating window to switch colorscheme (nvim + tmux) live
--
-- The list is parsed straight out of `lua/colorscheme-choice.lua`, so the
-- picker and the persistence target can never drift apart. Selecting a theme
-- applies it immediately and rewrites the *single* active line in the choice
-- files (nvim + tmux), leaving every other line untouched.
-- ============================================================================

local M = {}

local NVIM_CHOICE = vim.fn.stdpath("config") .. "/lua/colorscheme-choice.lua"
local TMUX_CHOICE = vim.fn.expand("~/.config/tmux/theme-choice.tmux")
local TMUX_CONF = vim.fn.expand("~/.tmux.conf")

local COLORSCHEME_PAT = [==[^%s*%-*%s*vim%.cmd%.colorscheme%(%s*["']([^"']+)["']]==]
local TMUX_SOURCE_PAT = "^%s*#*%s*source%-file%s+(%S+)"

-- nvim colorscheme -> tmux theme, for the pairs whose names do not match
local TMUX_OVERRIDES = {
  ["iterm2-dark-background"] = "iterm2-muted",
  ["solarized-osaka-night"] = "solarized-osaka",
  ["solarized-osaka-storm"] = "solarized-osaka",
  ["solarized-osaka-day"] = "solarized-osaka",
  ["kanagawa"] = "kanagawa-dragon",
  ["kanagawa-wave"] = "kanagawa-dragon",
  ["kanagawa-lotus"] = "kanagawa-dragon",
}

local ns = vim.api.nvim_create_namespace("theme_picker")

-- ---------------------------------------------------------------------------
-- File parsing / editing helpers
-- ---------------------------------------------------------------------------

local function read_lines(path)
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and lines or nil
end

local function is_commented(line, char)
  return line:match("^%s*" .. char) ~= nil
end

---Strip the leading comment marker, keeping the original indentation.
local function uncomment(line, char)
  local indent, rest = line:match("^(%s*)(.*)$")
  rest = rest:gsub("^" .. char .. "+%s*", "")
  return indent .. rest
end

---Add a comment marker unless the line already has one.
local function comment(line, char, marker)
  if is_commented(line, char) then
    return line
  end
  local indent, rest = line:match("^(%s*)(.*)$")
  if rest == "" then
    return line
  end
  return indent .. marker .. " " .. rest
end

---Tidy a section header comment into a short tag: "TOKYONIGHT variants" -> "TOKYONIGHT".
local function clean_group(text)
  text = text:gsub("^[%-#]+%s*", "")
  text = text:gsub("%s*%b()", "")
  text = text:gsub("%s+variants?%s*$", "")
  return vim.trim(text)
end

---Parse colorscheme-choice.lua into an ordered entry list.
---@return table|nil entries { name, lnum, active, group }
---@return string[]|nil lines
local function parse_nvim_choice()
  local lines = read_lines(NVIM_CHOICE)
  if not lines then
    return nil, nil
  end

  local entries, group = {}, ""
  for lnum, line in ipairs(lines) do
    local name = line:match(COLORSCHEME_PAT)
    if name then
      table.insert(entries, {
        name = name,
        lnum = lnum,
        active = not is_commented(line, "%-%-"),
        group = group,
      })
    elseif line:match("^%s*%-%-") and not line:match("^%s*%-%-%s*=+") then
      local tag = clean_group(line)
      if tag ~= "" then
        group = tag
      end
    end
  end

  return entries, lines
end

---Parse theme-choice.tmux into a map of theme name -> line number.
local function parse_tmux_choice()
  local lines = read_lines(TMUX_CHOICE)
  if not lines then
    return {}, nil
  end

  local themes = {}
  for lnum, line in ipairs(lines) do
    local path = line:match(TMUX_SOURCE_PAT)
    if path then
      local name = path:match("([^/]+)%.tmux$")
      if name then
        themes[name] = lnum
      end
    end
  end

  return themes, lines
end

local function tmux_counterpart(colorscheme, tmux_themes)
  local mapped = TMUX_OVERRIDES[colorscheme] or colorscheme
  return tmux_themes[mapped] and mapped or nil
end

---Comment every candidate line except `target_lnum`, which gets uncommented.
local function rewrite_choice(lines, candidate_lnums, target_lnum, char, marker)
  for _, lnum in ipairs(candidate_lnums) do
    if lnum == target_lnum then
      lines[lnum] = uncomment(lines[lnum], char)
    else
      lines[lnum] = comment(lines[lnum], char, marker)
    end
  end
  return lines
end

-- ---------------------------------------------------------------------------
-- Persistence
-- ---------------------------------------------------------------------------

---Refuse to write a file the user has open with unsaved changes: `checktime`
---would raise a blocking W12 prompt, and their next `:w` would clobber us.
local function dirty_buffer(path)
  local bufnr = vim.fn.bufnr(path)
  return bufnr ~= -1 and vim.bo[bufnr].modified
end

local function persist_nvim(entry)
  if dirty_buffer(NVIM_CHOICE) then
    return false, "colorscheme-choice.lua has unsaved changes — not written"
  end

  local entries, lines = parse_nvim_choice()
  if not entries or not lines then
    return false, "cannot read " .. NVIM_CHOICE
  end

  local lnums, target = {}, nil
  for _, e in ipairs(entries) do
    table.insert(lnums, e.lnum)
    if e.name == entry.name then
      target = e.lnum
    end
  end
  if not target then
    return false, entry.name .. " not found in colorscheme-choice.lua"
  end

  rewrite_choice(lines, lnums, target, "%-%-", "--")
  local ok = pcall(vim.fn.writefile, lines, NVIM_CHOICE)
  return ok, ok and nil or ("write failed: " .. NVIM_CHOICE)
end

local function persist_tmux(tmux_name)
  if dirty_buffer(TMUX_CHOICE) then
    return false, "theme-choice.tmux has unsaved changes"
  end

  local themes, lines = parse_tmux_choice()
  if not lines or not themes[tmux_name] then
    return false, "no tmux counterpart"
  end

  local lnums = {}
  for _, lnum in pairs(themes) do
    table.insert(lnums, lnum)
  end

  rewrite_choice(lines, lnums, themes[tmux_name], "#", "#")
  if not pcall(vim.fn.writefile, lines, TMUX_CHOICE) then
    return false, "write failed: " .. TMUX_CHOICE
  end

  if vim.env.TMUX then
    vim.system({ "tmux", "source-file", TMUX_CONF }, { text = true }, function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          vim.notify("tmux reload failed: " .. (res.stderr or ""), vim.log.levels.WARN)
        end)
      end
    end)
  end

  return true, nil
end

-- ---------------------------------------------------------------------------
-- Floating window
-- ---------------------------------------------------------------------------

local function render(buf, entries)
  local lines = {}
  for _, e in ipairs(entries) do
    table.insert(lines, string.format("%s %s", e.active and "●" or " ", e.name))
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for i, e in ipairs(entries) do
    local tag = e.tmux and ("⇄ " .. e.tmux) or "⇄ –"
    vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
      virt_text = {
        { tag, e.tmux and "DiagnosticHint" or "NonText" },
        { "  " .. e.group, "Comment" },
      },
      virt_text_pos = "right_align",
    })
    if e.active then
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { end_col = 1, hl_group = "DiagnosticOk" })
    end
  end
end

function M.open()
  local entries = parse_nvim_choice()
  if not entries or #entries == 0 then
    vim.notify("theme-picker: no colorschemes found in colorscheme-choice.lua", vim.log.levels.ERROR)
    return
  end

  local tmux_themes = parse_tmux_choice()
  local original, cursor_row = nil, 1
  for i, e in ipairs(entries) do
    e.tmux = tmux_counterpart(e.name, tmux_themes)
    if e.active then
      original = e.name
      cursor_row = i
    end
  end
  original = original or vim.g.colors_name

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "themepicker"
  render(buf, entries)

  local width = math.min(64, vim.o.columns - 4)
  local height = math.min(#entries, math.max(10, vim.o.lines - 8))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Theme picker ",
    title_pos = "center",
    footer = " <CR> apply · a nvim only · q cancel ",
    footer_pos = "center",
  })

  vim.wo[win].cursorline = true
  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:CursorLine"
  vim.api.nvim_win_set_cursor(win, { cursor_row, 0 })

  local group = vim.api.nvim_create_augroup("ThemePickerPreview", { clear = true })
  local last_row, broken = cursor_row, {}

  local function preview(row)
    local e = entries[row]
    if not e or broken[e.name] then
      return
    end
    if not pcall(vim.cmd.colorscheme, e.name) then
      broken[e.name] = true
      vim.api.nvim_buf_set_extmark(buf, ns, row - 1, 0, {
        virt_text = { { " ✗ not installed", "DiagnosticError" } },
        virt_text_pos = "eol",
      })
      pcall(vim.cmd.colorscheme, original)
    end
  end

  local function close()
    pcall(vim.api.nvim_del_augroup_by_id, group)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function cancel()
    close()
    pcall(vim.cmd.colorscheme, original)
  end

  local function apply(sync_tmux)
    local e = entries[vim.api.nvim_win_get_cursor(win)[1]]
    close()
    if not e or broken[e.name] then
      pcall(vim.cmd.colorscheme, original)
      if e then
        vim.notify("theme-picker: " .. e.name .. " is not installed", vim.log.levels.WARN)
      end
      return
    end

    pcall(vim.cmd.colorscheme, e.name)

    local ok, err = persist_nvim(e)
    if not ok then
      vim.notify("theme-picker: " .. err, vim.log.levels.ERROR)
      return
    end

    local msg = "theme: " .. e.name
    if sync_tmux and e.tmux then
      local tok, terr = persist_tmux(e.tmux)
      msg = msg .. (tok and (" ⇄ tmux " .. e.tmux) or (" (tmux: " .. terr .. ")"))
    elseif sync_tmux then
      msg = msg .. " (no tmux counterpart)"
    end

    vim.cmd.checktime()
    vim.notify(msg, vim.log.levels.INFO)
  end

  -- nested: the preview fires ColorScheme, which other autocmds (the custom
  -- highlight overrides, lualine, bufferline) must still see
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = buf,
    nested = true,
    callback = function()
      local row = vim.api.nvim_win_get_cursor(win)[1]
      if row ~= last_row then
        last_row = row
        preview(row)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    buffer = buf,
    once = true,
    callback = cancel,
  })

  local map = function(lhs, fn)
    vim.keymap.set("n", lhs, fn, { buffer = buf, nowait = true, silent = true })
  end
  map("<CR>", function()
    apply(true)
  end)
  map("a", function()
    apply(false)
  end)
  map("q", cancel)
  map("<Esc>", cancel)
end

return M
