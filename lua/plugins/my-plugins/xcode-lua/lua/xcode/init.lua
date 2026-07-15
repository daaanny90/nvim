-- Xcode Colorscheme for Neovim
-- A faithful recreation of Apple's Xcode IDE color scheme
-- Supports Treesitter, LSP semantic tokens, and popular plugins

local M = {}

M.config = {
  style = "dark", -- "dark" or "light"
  transparent = false, -- Enable transparent background
  italic_comments = true, -- Use italics for comments
  bold_keywords = false, -- Use bold for keywords (false for softer look)
  terminal_colors = true, -- Set terminal colors
  hide_inactive_statusline = false, -- Hide inactive statuslines
  dim_inactive = false, -- Dim inactive windows
  lualine_bold = false, -- Bold section headers in lualine
}

---@param opts? table
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.load(style)
  style = style or M.config.style

  -- Clear existing highlights
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = style == "light" and "light" or "dark"
  vim.g.colors_name = "xcode-" .. style

  -- Load palette
  local palette = require("xcode.palette").get_palette(style)

  -- Load highlight groups
  require("xcode.groups").setup(palette, M.config)

  -- Load plugin highlights
  require("xcode.plugins").setup(palette, M.config)

  -- Set terminal colors
  if M.config.terminal_colors then
    M.set_terminal_colors(palette)
  end

  -- Dim inactive windows
  if M.config.dim_inactive then
    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        vim.wo.winhighlight = ""
      end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
      callback = function()
        vim.wo.winhighlight = "Normal:NormalNC"
      end,
    })
  end
end

function M.set_terminal_colors(p)
  -- Terminal colors (for :terminal)
  vim.g.terminal_color_0 = p.bg_dark -- black
  vim.g.terminal_color_1 = p.red -- red
  vim.g.terminal_color_2 = p.green -- green
  vim.g.terminal_color_3 = p.yellow -- yellow
  vim.g.terminal_color_4 = p.blue -- blue
  vim.g.terminal_color_5 = p.purple -- magenta
  vim.g.terminal_color_6 = p.cyan -- cyan
  vim.g.terminal_color_7 = p.fg -- white

  vim.g.terminal_color_8 = p.comment -- bright black
  vim.g.terminal_color_9 = p.red -- bright red
  vim.g.terminal_color_10 = p.mint -- bright green
  vim.g.terminal_color_11 = p.orange -- bright yellow
  vim.g.terminal_color_12 = p.cyan -- bright blue
  vim.g.terminal_color_13 = p.lavender -- bright magenta
  vim.g.terminal_color_14 = p.cyan -- bright cyan
  vim.g.terminal_color_15 = p.fg -- bright white
end

-- Lualine theme
function M.lualine_theme(style)
  style = style or M.config.style
  local p = require("xcode.palette").get_palette(style)
  local bold = M.config.lualine_bold

  return {
    normal = {
      a = { fg = p.bg, bg = p.pink, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    insert = {
      a = { fg = p.bg, bg = p.green, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    visual = {
      a = { fg = p.bg, bg = p.purple, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    replace = {
      a = { fg = p.bg, bg = p.red, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    command = {
      a = { fg = p.bg, bg = p.orange, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    terminal = {
      a = { fg = p.bg, bg = p.cyan, bold = bold },
      b = { fg = p.fg, bg = p.bg_highlight },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
    inactive = {
      a = { fg = p.comment, bg = p.bg_statusline },
      b = { fg = p.comment, bg = p.bg_statusline },
      c = { fg = p.comment, bg = p.bg_statusline },
    },
  }
end

-- Expose palette for external use
function M.palette(style)
  return require("xcode.palette").get_palette(style or M.config.style)
end

return M
