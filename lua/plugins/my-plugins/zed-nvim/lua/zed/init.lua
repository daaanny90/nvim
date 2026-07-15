-- Zed Colorscheme for Neovim
-- Recreates the look of the Zed editor (colors, calm/clean UI).
-- Switchable variants:
--   :colorscheme zed-one-dark     -> Zed "One Dark"
--   :colorscheme zed-ayu-mirage   -> Zed "Ayu Mirage"
--   :colorscheme zed-graph-paper  -> custom drafting-mat palette
--   :colorscheme zed-oscilloscope -> custom graphite + phosphor green
--   :colorscheme zed-blueprint    -> custom Prussian blue + ice cyan
-- Supports Treesitter, LSP semantic tokens, and popular plugins.

local M = {}

M.config = {
  variant = "one-dark", -- any variant name defined in zed/palette.lua
  transparent = false, -- transparent background
  italic_comments = true, -- italic comments (Zed default)
  bold_keywords = false, -- keep keywords regular (Zed look)
  terminal_colors = true, -- set :terminal ANSI colors
}

---@param opts? table
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---@param variant string|nil variant name (see zed/palette.lua)
function M.load(variant)
  variant = variant or M.config.variant

  -- Reset any previously applied colorscheme (clean variant switching)
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "zed-" .. variant

  local palette = require("zed.palette").get_palette(variant)

  require("zed.groups").setup(palette, M.config)
  require("zed.plugins").setup(palette, M.config)

  if M.config.terminal_colors then
    M.set_terminal_colors(palette)
  end
end

function M.set_terminal_colors(p)
  local t = p.terminal
  vim.g.terminal_color_0 = t.black
  vim.g.terminal_color_1 = t.red
  vim.g.terminal_color_2 = t.green
  vim.g.terminal_color_3 = t.yellow
  vim.g.terminal_color_4 = t.blue
  vim.g.terminal_color_5 = t.magenta
  vim.g.terminal_color_6 = t.cyan
  vim.g.terminal_color_7 = t.white
  vim.g.terminal_color_8 = t.br_black
  vim.g.terminal_color_9 = t.br_red
  vim.g.terminal_color_10 = t.br_green
  vim.g.terminal_color_11 = t.br_yellow
  vim.g.terminal_color_12 = t.br_blue
  vim.g.terminal_color_13 = t.br_magenta
  vim.g.terminal_color_14 = t.br_cyan
  vim.g.terminal_color_15 = t.br_white
end

-- Public helpers (parity with other local colorschemes in this config)
function M.palette(variant)
  return require("zed.palette").get_palette(variant or M.config.variant)
end

return M
