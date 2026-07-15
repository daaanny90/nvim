-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Check for Neovim update (Homebrew) in background, for statusline indicator
vim.g.nvim_update_available = false
vim.defer_fn(function()
  if vim.fn.executable("brew") ~= 1 then
    return
  end
  vim.fn.jobstart({ "brew", "outdated", "neovim" }, {
    stdout_buffered = true,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.schedule(function()
          vim.g.nvim_update_available = true
        end)
      end
    end,
  })
end, 5000)

-- Mason: check pacchetti outdated in background (per statusline)
vim.g.mason_outdated_count = 0
local mason_check_timer
local function mason_check_outdated()
  local ok, registry = pcall(require, "mason-registry")
  if not ok or not registry then
    return
  end
  registry.update(function(update_ok)
    if not update_ok then
      return
    end
    vim.schedule(function()
      local count = 0
      local ok2, pkgs = pcall(registry.get_installed_packages)
      if ok2 and pkgs then
        for _, pkg in ipairs(pkgs) do
          local ok3, cur, latest = pcall(function()
            return pkg:get_installed_version(), pkg:get_latest_version()
          end)
          if ok3 and cur and latest and cur ~= latest then
            count = count + 1
          end
        end
      end
      vim.g.mason_outdated_count = count
    end)
  end)
end
local function mason_check_debounced()
  if mason_check_timer then
    mason_check_timer:close()
  end
  mason_check_timer = vim.defer_fn(mason_check_outdated, 1500)
end
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    vim.defer_fn(mason_check_outdated, 8000)
    -- Ascolta install Mason per aggiornare l'avviso subito dopo update
    vim.defer_fn(function()
      local ok, registry = pcall(require, "mason-registry")
      if ok and registry then
        registry:on("package:install:success", mason_check_debounced)
      end
    end, 8500)
  end,
})
-- Ricontrolla quando chiudi Mason
vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "*",
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "mason" then
      vim.defer_fn(mason_check_outdated, 500)
    end
  end,
})

-- italic comments for xcode colorscheme
-- FIXME: it does not work in tmux
vim.cmd([[
  augroup vim-colors-xcode
    autocmd!
    autocmd ColorScheme * highlight Comment gui=italic cterm=italic
    autocmd ColorScheme * highlight SpecialComment gui=italic cterm=italic
  augroup END
]])
