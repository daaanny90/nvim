-- Custom commands for project workflows

-- Pre-commit checks command
local function run_pre_commit_checks()
  local checks = {
    { name = "Unit Tests", cmd = "pnpm run test:unit" },
    { name = "Type Check", cmd = "pnpm run type-check" },
    { name = "Lint", cmd = "pnpm run lint" },
  }

  -- Find project root
  local root = vim.fs.root(0, { "package.json", ".git" })
  if not root then
    vim.notify("⚠️  Not in a project directory", vim.log.levels.WARN)
    return
  end

  -- Create a floating window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 🚀 Pre-Commit Checks ",
    title_pos = "center",
  })

  -- Set buffer options
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "precommit"

  -- Set window options
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = true

  local results = {}
  local current_check = 1
  local lines = {}

  local update_pending = false
  local highlights = {}

  local function append_line(line, hl_group)
    table.insert(lines, line)
    if hl_group then
      table.insert(highlights, { line = #lines - 1, hl_group = hl_group })
    end
  end

  local function update_display()
    if update_pending then
      return
    end
    update_pending = true

    vim.schedule(function()
      -- Update buffer content
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      -- Apply highlights
      for _, hl in ipairs(highlights) do
        if hl.line < #lines then
          vim.api.nvim_buf_add_highlight(buf, -1, hl.hl_group, hl.line, 0, -1)
        end
      end

      -- Auto-scroll to bottom if window is still valid
      if vim.api.nvim_win_is_valid(win) then
        local line_count = #lines
        if line_count > 0 then
          vim.api.nvim_win_set_cursor(win, { line_count, 0 })
        end
      end

      update_pending = false
    end)
  end

  local function run_next_check()
    if current_check > #checks then
      -- All checks done, show summary
      append_line("")
      append_line("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Comment")
      append_line("📊 SUMMARY", "Title")
      append_line("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Comment")
      append_line("")

      local all_passed = true
      for _, result in ipairs(results) do
        local icon = result.success and "✅" or "❌"
        local status = result.success and "PASSED" or "FAILED"
        append_line(string.format("  %s %s: %s", icon, result.name, status), result.success and "String" or "Error")
        all_passed = all_passed and result.success
      end

      append_line("")
      if all_passed then
        append_line("🎉 All checks passed! Ready to push.", "String")
        vim.notify("✅ All pre-commit checks passed!", vim.log.levels.INFO)
      else
        append_line("❌ Some checks failed. Please fix issues before pushing.", "Error")
        vim.notify("❌ Pre-commit checks failed!", vim.log.levels.ERROR)
      end
      append_line("")
      append_line("Press 'q' or <Esc> to close this window", "Comment")
      update_display()

      -- Set keymaps to close window
      vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf, silent = true })
      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf, silent = true })
      return
    end

    local check = checks[current_check]
    append_line("")
    append_line("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Comment")
    append_line(string.format("🔄 Running: %s (%d/%d)", check.name, current_check, #checks), "Title")
    append_line("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Comment")
    append_line("")
    update_display()

    vim.notify(string.format("🔄 Running: %s", check.name), vim.log.levels.INFO)

    local output_lines = {}
    local last_update = vim.loop.now()
    local update_interval = 100 -- Update display every 100ms

    -- Run the check
    vim.fn.jobstart(check.cmd, {
      cwd = root,
      env = vim.fn.extend(vim.fn.environ(), { NODE_ENV = "development" }),
      stdout_buffered = false,
      stderr_buffered = false,
      on_stdout = function(_, data)
        if data then
          for _, line in ipairs(data) do
            if line ~= "" then
              table.insert(output_lines, line)
              append_line(line)
            end
          end
          -- Throttle updates to avoid too many redraws
          local now = vim.loop.now()
          if now - last_update > update_interval then
            update_display()
            last_update = now
          end
        end
      end,
      on_stderr = function(_, data)
        if data then
          for _, line in ipairs(data) do
            if line ~= "" then
              table.insert(output_lines, line)
              append_line(line, "WarningMsg")
            end
          end
          -- Throttle updates to avoid too many redraws
          local now = vim.loop.now()
          if now - last_update > update_interval then
            update_display()
            last_update = now
          end
        end
      end,
      on_exit = function(_, exit_code)
        local success = exit_code == 0
        table.insert(results, { name = check.name, success = success, output = output_lines })

        append_line("")
        if success then
          append_line(string.format("✅ %s completed successfully", check.name), "String")
        else
          append_line(string.format("❌ %s failed with exit code %d", check.name, exit_code), "Error")
          -- Show output summary if failed
          if #output_lines > 0 then
            append_line(string.format("   Output lines captured: %d", #output_lines), "Comment")
          end
        end
        update_display()

        current_check = current_check + 1
        vim.schedule(run_next_check)
      end,
    })
  end

  -- Start first check
  append_line(string.format("📁 Project: %s", root), "Comment")
  append_line("")
  update_display()
  run_next_check()
end

-- Create user command
vim.api.nvim_create_user_command("PreCommitCheck", run_pre_commit_checks, {
  desc = "Run pre-commit checks (tests, type-check, lint)",
})

-- Optional: Add a keymap (you can change this to whatever you prefer)
vim.keymap.set("n", "<leader>pc", run_pre_commit_checks, { desc = "[P]re-[C]ommit checks" })

-- Weekly Report Generator
local function generate_weekly_report()
  -- Get current date/time
  local now = os.time()
  
  -- Get current day of week (0=Sunday, 1=Monday, ..., 6=Saturday)
  local current_weekday = tonumber(os.date("%w", now))
  
  -- Convert to Monday=1, ..., Friday=5, Saturday=6, Sunday=7
  if current_weekday == 0 then
    current_weekday = 7
  end
  
  -- Calculate days until Friday (5)
  local days_until_friday = 5 - current_weekday
  
  -- Get Friday's timestamp
  local friday_timestamp = now + (days_until_friday * 24 * 60 * 60)
  
  -- Format date as DD.MM.YY
  local friday_date = os.date("%d.%m.%y", friday_timestamp)
  
  -- Get week number for the subject line
  local week_number = os.date("%V", friday_timestamp)
  
  -- Email subject line
  local subject = string.format("Weekly Report - KW %s", week_number)
  
  -- Create the template
  local template = {
    subject,
    "",
    "",
    "Wer:",
    "",
    "Danny Spina",
    "",
    "Wann:",
    "",
    friday_date,
    "",
    "Progress (Was habe ich letzte Woche erreicht?):",
    "",
    "",
    "",
    "Plans (Was nehme ich mir für die nächste Woche vor?):",
    "",
    "",
    "",
    "Problems (Was hindert mich gerade daran, meine Arbeit zu tun?):",
    "",
    "",
    "",
    "Personal (Welche Infos halte ich darüber hinaus persönlich noch als wichtig?):",
    "",
    "",
    "",
    "Legende: Bitte in Fett, wenn ich dich darauf ansprechen soll. Bitte in Kursiv, wenn es vertraulich ist. Bitte Fett-Kursiv, wenn beides zutrifft.",
    "",
  }
  
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(true, false)
  
  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, template)
  
  -- Switch to the new buffer
  vim.api.nvim_set_current_buf(buf)
  
  -- Set buffer options
  vim.bo[buf].filetype = "text"
  vim.bo[buf].buftype = ""
  
  -- Set cursor to first empty line after "Progress"
  vim.api.nvim_win_set_cursor(0, {13, 0})
  
  vim.notify(string.format("📝 Weekly report template created for %s (KW %s)", friday_date, week_number), vim.log.levels.INFO)
end

-- Create user command
vim.api.nvim_create_user_command("Weekly", generate_weekly_report, {
  desc = "Generate weekly report template with automatic date and subject",
})

-- Optional: Add a keymap
vim.keymap.set("n", "<leader>wr", generate_weekly_report, { desc = "[W]eekly [R]eport" })

