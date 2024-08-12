-- fix for solarized osaka coloscheme, comment out if not in use
local hslutil = require 'solarized-osaka.hsl'
local hsl = hslutil.hslToHex

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function current_working_dir()
  local cwd = string.sub(vim.fn.getcwd(), 12)
  return '~' .. cwd
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  else
    return 'Recording @' .. recording_register
  end
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  lazy = true,
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        always_divide_middle = false,
        theme = 'auto',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'b:gitsigns_head', icon = { '' } },
          {
            'diff',
            source = diff_source,
            -- fix for solarized osaka coloscheme, comment out if not in use
            color = { bg = hsl(192, 100, 5) },
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            -- fix for solarized osaka coloscheme, comment out if not in use
            color = { bg = hsl(192, 100, 5) },
          },
        },
        lualine_c = {
          { 'filename', path = 1, symbols = { modified = '[]', readonly = ' ' } },
          { 'lsp_progress', display_components = { 'lsp_client_name' } },
        },
        lualine_x = {
          {
            'macro-recording',
            fmt = show_macro_recording,
          },
          { 'filetype', icon_only = true },
        },
        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { current_working_dir },
        },
        lualine_z = { { 'location' } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1, symbols = { modified = '[]', readonly = ' ' } } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'neo-tree', 'lazy' },
    }
  end,
}
