-- Xcode Color Palette
-- Authentic colors from Xcode IDE - softer, more muted tones

local M = {}

-- Dark theme palette (Xcode Default Dark - muted version)
M.dark = {
  -- Base colors - slightly warmer, less harsh
  bg = "#292A30",
  bg_dark = "#232429",
  bg_float = "#2F3037",
  bg_highlight = "#323339",
  bg_popup = "#333840",
  bg_search = "#4A5568",
  bg_sidebar = "#252629",
  bg_statusline = "#2D2E34",
  bg_visual = "#3A3D46",

  -- Foreground colors - softer white
  fg = "#DFDFE0",
  fg_dark = "#BFBFC1",
  fg_gutter = "#53606E",
  fg_sidebar = "#9DA5B4",

  -- Syntax colors (muted, authentic Xcode)
  red = "#FC6A5D",           -- Strings (coral, slightly muted)
  orange = "#D9A760",        -- Preprocessor, macros (warmer, softer)
  yellow = "#D0C57A",        -- Numbers, characters (muted gold)
  green = "#78C2B3",         -- Variables, properties (soft teal)
  mint = "#9CDCCF",          -- Other class names (soft mint)
  cyan = "#6BDFFF",          -- URLs, system types (soft cyan)
  blue = "#5DAFCE",          -- Other declarations (muted blue)
  purple = "#B281EB",        -- Functions, methods (soft purple)
  pink = "#FF7AB2",          -- Keywords (soft pink/magenta)
  lavender = "#DABAFF",      -- Project types (soft lavender)

  -- UI colors
  border = "#454851",
  comment = "#7F8C98",
  cursor = "#DFDFE0",
  error = "#EF6B73",
  warning = "#E5A95C",
  info = "#6BDFFF",
  hint = "#78C2B3",
  selection = "#4A5568",

  -- Git colors (softer)
  git_add = "#78C2B3",
  git_change = "#D0C57A",
  git_delete = "#EF6B73",

  -- Diff colors (subtle)
  diff_add = "#2A3830",
  diff_change = "#383828",
  diff_delete = "#382A2A",
  diff_text = "#3D3D2D",

  -- Special
  none = "NONE",
}

-- Light theme palette (Xcode Default Light - softer)
M.light = {
  -- Base colors
  bg = "#FFFFFF",
  bg_dark = "#F7F7F7",
  bg_float = "#F2F2F2",
  bg_highlight = "#ECEDEE",
  bg_popup = "#EFEFEF",
  bg_search = "#FFE066",
  bg_sidebar = "#F5F5F7",
  bg_statusline = "#EAEAEB",
  bg_visual = "#D6E4F8",

  -- Foreground colors - softer black
  fg = "#262626",
  fg_dark = "#3D3D3D",
  fg_gutter = "#B8B8B8",
  fg_sidebar = "#6E6E73",

  -- Syntax colors (muted, authentic Xcode light)
  red = "#C41A16",           -- Strings
  orange = "#78492A",        -- Preprocessor, macros (brown, muted)
  yellow = "#1C00CF",        -- Numbers (actually blue in light mode)
  green = "#3E8087",         -- Variables, properties (soft teal)
  mint = "#326D74",          -- Other class names
  cyan = "#0B4F79",          -- URLs, system types (softer)
  blue = "#0B4F79",          -- Other declarations
  purple = "#5D2E8C",        -- Functions, methods, types (muted)
  pink = "#9B2393",          -- Keywords (muted magenta)
  lavender = "#6C36A9",      -- Project types

  -- UI colors
  border = "#D1D1D6",
  comment = "#6B7D8A",
  cursor = "#262626",
  error = "#C41A16",
  warning = "#8B5A00",
  info = "#0B4F79",
  hint = "#3E8087",
  selection = "#D6E4F8",

  -- Git colors
  git_add = "#3E8087",
  git_change = "#8B5A00",
  git_delete = "#C41A16",

  -- Diff colors (subtle)
  diff_add = "#E6F4EA",
  diff_change = "#FEF7E0",
  diff_delete = "#FCE8E6",
  diff_text = "#D4EDDA",

  -- Special
  none = "NONE",
}

-- Get palette based on background
function M.get_palette(style)
  style = style or vim.o.background
  if style == "light" then
    return M.light
  end
  return M.dark
end

return M
