-- Zed Colorscheme Palette
-- Faithful recreation of the Zed editor themes:
--   * "one-dark"    -> Zed "One Dark"
--   * "ayu-mirage"  -> Zed "Ayu Mirage"
--   * "graph-paper" -> custom palette (dark drafting mat: olive-charcoal
--                      paper, sage grid lines, burnt-orange ruler marks)
--   * "oscilloscope" -> custom (graphite instrument body, phosphor-green
--                       accent, amber/cyan trace channels)
--   * "blueprint"   -> custom (Prussian-blue cyanotype, ice-cyan accent)
-- One Dark / Ayu Mirage hex values taken verbatim from Zed's theme JSON
-- (zed-industries/zed); graph-paper is an original palette in Zed's style.
-- Keys are SEMANTIC (by role, not hue) so a single groups.lua maps every
-- highlight group once while each variant supplies its own authentic color.

local M = {}

M["one-dark"] = {
  -- UI surfaces
  bg = "#282c33", -- editor.background
  bg_dark = "#22262d", -- darker shade (bufferline fill, NormalNC)
  bg_float = "#2f343e", -- elevated_surface.background (floats, popups)
  bg_highlight = "#2f343e", -- active line / surface
  bg_popup = "#2f343e",
  bg_sidebar = "#282c33", -- seamless panels (Zed-clean)
  bg_statusline = "#282c33",
  bg_visual = "#3a4b5e", -- players[0].selection (#74ade8 @24%) blended over bg
  bg_selected = "#454a56", -- element.selected (menu selection)
  -- Foreground / gutter
  fg = "#acb2be", -- editor.foreground
  fg_dark = "#a9afbc", -- text.muted
  fg_gutter = "#4e5a5f", -- editor.line_number
  fg_sidebar = "#838994",
  fg_active_nr = "#d0d4da", -- active_line_number
  -- Chrome
  comment = "#5d636f",
  border = "#464b57",
  cursor = "#74ade8",
  accent = "#74ade8", -- text.accent
  -- Status / diagnostics
  error = "#d07277",
  warning = "#dec184",
  info = "#74ade8",
  hint = "#788ca6",
  ok = "#a1c181",
  -- Git / VCS
  git_add = "#a1c181",
  git_change = "#dec184",
  git_delete = "#d07277",
  diff_add = "#2b3a2c",
  diff_change = "#33352b",
  diff_delete = "#3c2a2d",
  diff_text = "#414327",
  -- Syntax (by role)
  s_keyword = "#b477cf",
  s_func = "#73ade9",
  s_string = "#a1c181",
  s_type = "#6eb4bf",
  s_number = "#bf956a",
  s_constant = "#dfc184",
  s_var = "#acb2be",
  s_property = "#d07277",
  s_param = "#acb2be",
  s_operator = "#6eb4bf",
  s_tag = "#74ade8",
  s_attribute = "#74ade8",
  s_constructor = "#73ade9",
  s_preproc = "#b477cf",
  s_punct = "#b2b9c6",
  s_title = "#d07277",
  s_special = "#bf956a", -- regex / special chars
  s_escape = "#878e98", -- string.escape, comment.doc
  s_builtin = "#bf956a", -- variable.builtin / function.builtin
  s_namespace = "#acb2be",
  s_label = "#74ade8",
  s_link = "#6eb4bf", -- link_uri
  s_link_text = "#73ade9",
  none = "NONE",
  -- Terminal ANSI (verbatim from Zed terminal.ansi.*)
  terminal = {
    black = "#282c34",
    red = "#e06c75",
    green = "#98c379",
    yellow = "#e5c07b",
    blue = "#61afef",
    magenta = "#c678dd",
    cyan = "#56b6c2",
    white = "#abb2bf",
    br_black = "#636d83",
    br_red = "#ea858b",
    br_green = "#aad581",
    br_yellow = "#ffd885",
    br_blue = "#85c1ff",
    br_magenta = "#d398eb",
    br_cyan = "#6ed5de",
    br_white = "#fafafa",
  },
}

M["ayu-mirage"] = {
  -- UI surfaces
  bg = "#242835", -- editor.background
  bg_dark = "#1f222e",
  bg_float = "#353944", -- elevated_surface.background
  bg_highlight = "#353944",
  bg_popup = "#353944",
  bg_sidebar = "#242835",
  bg_statusline = "#242835",
  bg_visual = "#375065", -- players[0].selection (#72cffe @24%) blended over bg
  bg_selected = "#53565d", -- element.selected
  -- Foreground / gutter
  fg = "#cccac2", -- editor.foreground
  fg_dark = "#9a9a98", -- text.muted
  fg_gutter = "#575c6b", -- editor.line_number
  fg_sidebar = "#7b7d7f",
  fg_active_nr = "#e1e3ea",
  -- Chrome
  comment = "#5c6773",
  border = "#53565d",
  cursor = "#72cffe",
  accent = "#72cffe",
  -- Status / diagnostics
  error = "#f18779",
  warning = "#fecf72",
  info = "#72cffe",
  hint = "#7399a3",
  ok = "#d5fe80",
  -- Git / VCS
  git_add = "#d5fe80",
  git_change = "#fecf72",
  git_delete = "#f18779",
  diff_add = "#2f3d1e",
  diff_change = "#3d2f15",
  diff_delete = "#3a1f20",
  diff_text = "#4a3a12",
  -- Syntax (by role)
  s_keyword = "#ffad65",
  s_func = "#ffd173",
  s_string = "#d4fe7f",
  s_type = "#73cfff",
  s_number = "#dfbfff",
  s_constant = "#dfbfff",
  s_var = "#cccac2",
  s_property = "#72cffe",
  s_param = "#cccac2",
  s_operator = "#f29e74",
  s_tag = "#72cffe",
  s_attribute = "#72cffe",
  s_constructor = "#72cffe",
  s_preproc = "#ffad65",
  s_punct = "#b4b3ae",
  s_title = "#cccac2",
  s_special = "#95e6cb", -- regex
  s_escape = "#9b9b99",
  s_builtin = "#f29e74",
  s_namespace = "#cccac2",
  s_label = "#72cffe",
  s_link = "#d5fe80",
  s_link_text = "#fead66",
  none = "NONE",
  -- Terminal ANSI (verbatim from Zed terminal.ansi.*)
  terminal = {
    black = "#242835",
    red = "#f18779",
    green = "#d5fe80",
    yellow = "#fecf72",
    blue = "#72cffe",
    magenta = "#5bcde5",
    cyan = "#95e5cb",
    white = "#cccac2",
    br_black = "#67696e",
    br_red = "#833f3c",
    br_green = "#75993c",
    br_yellow = "#937237",
    br_blue = "#336d8d",
    br_magenta = "#2b6c7b",
    br_cyan = "#4c806f",
    br_white = "#fafafa",
  },
}

M["graph-paper"] = {
  -- UI surfaces
  bg = "#2a2a24", -- dark olive-charcoal paper
  bg_dark = "#242420", -- darker shade (bufferline fill, NormalNC)
  bg_float = "#32322a", -- elevated surface (floats, popups)
  bg_highlight = "#32322a", -- active line / surface
  bg_popup = "#32322a",
  bg_sidebar = "#2a2a24", -- seamless panels (Zed-clean)
  bg_statusline = "#2a2a24",
  bg_visual = "#483626", -- ruler orange @20% blended over bg
  bg_selected = "#3c3c33", -- element.selected (menu selection)
  -- Foreground / gutter
  fg = "#c5c2b0", -- warm paper white
  fg_dark = "#b0ad9c", -- text.muted
  fg_gutter = "#565b4c", -- line numbers = minor grid lines
  fg_sidebar = "#8b8d7d",
  fg_active_nr = "#cc8447", -- current position = orange ruler tick
  -- Chrome
  comment = "#6e7260", -- sage gray
  border = "#41453a", -- borders = grid lines
  cursor = "#c2662f", -- burnt orange (major ruler line)
  accent = "#c2662f",
  -- Status / diagnostics
  error = "#cf5f4a",
  warning = "#d2a24c",
  info = "#8fa792",
  hint = "#7d816c",
  ok = "#a4b17c",
  -- Git / VCS
  git_add = "#a4b17c",
  git_change = "#d2a24c",
  git_delete = "#cf5f4a",
  diff_add = "#333a28",
  diff_change = "#3a3526",
  diff_delete = "#3e2c26",
  diff_text = "#4a4228",
  -- Syntax (by role)
  s_keyword = "#c2662f", -- burnt orange
  s_func = "#d5a458", -- amber
  s_string = "#a4b17c", -- olive sage
  s_type = "#8fa792", -- gray-teal (brightened grid green)
  s_number = "#c78a52",
  s_constant = "#dabb80",
  s_var = "#c5c2b0",
  s_property = "#c97a5a", -- muted terracotta
  s_param = "#c5c2b0",
  s_operator = "#8fa792",
  s_tag = "#c2662f",
  s_attribute = "#cc8447",
  s_constructor = "#d5a458",
  s_preproc = "#c2662f",
  s_punct = "#a8a795",
  s_title = "#c97a5a",
  s_special = "#c78a52", -- regex / special chars
  s_escape = "#8b8d7d", -- string.escape, comment.doc
  s_builtin = "#c78a52", -- variable.builtin / function.builtin
  s_namespace = "#c5c2b0",
  s_label = "#cc8447",
  s_link = "#8fa792", -- link_uri
  s_link_text = "#d5a458",
  none = "NONE",
  -- Terminal ANSI
  terminal = {
    black = "#2a2a24",
    red = "#cf5f4a",
    green = "#a4b17c",
    yellow = "#d2a24c",
    blue = "#7e99a3",
    magenta = "#c47a62",
    cyan = "#8fa792",
    white = "#c5c2b0",
    br_black = "#6e7260",
    br_red = "#dd7862",
    br_green = "#b5c28c",
    br_yellow = "#e0b464",
    br_blue = "#93aeb8",
    br_magenta = "#d69a80",
    br_cyan = "#a3bba6",
    br_white = "#e8e4d4",
  },
}

M["oscilloscope"] = {
  -- UI surfaces
  bg = "#1e1f1c", -- neutral graphite (instrument body)
  bg_dark = "#181916", -- darker shade (bufferline fill, NormalNC)
  bg_float = "#262723", -- elevated surface (floats, popups)
  bg_highlight = "#262723", -- active line / surface
  bg_popup = "#262723",
  bg_sidebar = "#1e1f1c", -- seamless panels (Zed-clean)
  bg_statusline = "#1e1f1c",
  bg_visual = "#35422d", -- phosphor green @20% blended over bg
  bg_selected = "#2f302b", -- element.selected (menu selection)
  -- Foreground / gutter
  fg = "#c4c9bc",
  fg_dark = "#adb2a5", -- text.muted
  fg_gutter = "#4d5347", -- line numbers
  fg_sidebar = "#878e7f",
  fg_active_nr = "#a5e287", -- current position = bright phosphor
  -- Chrome
  comment = "#667058",
  border = "#383b34",
  cursor = "#8fd072", -- phosphor green
  accent = "#8fd072",
  -- Status / diagnostics
  error = "#d96a5a",
  warning = "#d9b56a",
  info = "#7ec7c4",
  hint = "#7d8471",
  ok = "#8fd072",
  -- Git / VCS
  git_add = "#8fd072",
  git_change = "#d9b56a",
  git_delete = "#d96a5a",
  diff_add = "#263222",
  diff_change = "#383122",
  diff_delete = "#3a2723",
  diff_text = "#524730",
  -- Syntax (by role)
  s_keyword = "#8fd072", -- phosphor green
  s_func = "#7ec7c4", -- cyan channel 2
  s_string = "#d9b56a", -- amber channel 1
  s_type = "#a3c4ae", -- pale sea green
  s_number = "#e0c184",
  s_constant = "#ecd7a4",
  s_var = "#c4c9bc",
  s_property = "#b8c2a6",
  s_param = "#c4c9bc",
  s_operator = "#9fc4b8",
  s_tag = "#8fd072",
  s_attribute = "#a5e287",
  s_constructor = "#7ec7c4",
  s_preproc = "#8fd072",
  s_punct = "#8b9183",
  s_title = "#d9b56a",
  s_special = "#e0c184", -- regex / special chars
  s_escape = "#8a917f", -- string.escape, comment.doc
  s_builtin = "#e0c184", -- variable.builtin / function.builtin
  s_namespace = "#c4c9bc",
  s_label = "#a5e287",
  s_link = "#7ec7c4", -- link_uri
  s_link_text = "#d9b56a",
  none = "NONE",
  -- Terminal ANSI
  terminal = {
    black = "#1e1f1c",
    red = "#d96a5a",
    green = "#8fd072",
    yellow = "#d9b56a",
    blue = "#7ea8c4",
    magenta = "#b98a9c",
    cyan = "#7ec7c4",
    white = "#c4c9bc",
    br_black = "#667058",
    br_red = "#e58273",
    br_green = "#a5e287",
    br_yellow = "#e6c884",
    br_blue = "#93bcd4",
    br_magenta = "#cba2b2",
    br_cyan = "#97d6d3",
    br_white = "#e5e8de",
  },
}

M["blueprint"] = {
  -- UI surfaces
  bg = "#212b36", -- Prussian blue (cyanotype paper)
  bg_dark = "#1a232d", -- darker shade (bufferline fill, NormalNC)
  bg_float = "#2a3542", -- elevated surface (floats, popups)
  bg_highlight = "#2a3542", -- active line / surface
  bg_popup = "#2a3542",
  bg_sidebar = "#212b36", -- seamless panels (Zed-clean)
  bg_statusline = "#212b36",
  bg_visual = "#354757", -- ice cyan @20% blended over bg
  bg_selected = "#344252", -- element.selected (menu selection)
  -- Foreground / gutter
  fg = "#c3cfda",
  fg_dark = "#aab7c4", -- text.muted
  fg_gutter = "#4d5b68", -- line numbers
  fg_sidebar = "#8595a3",
  fg_active_nr = "#9cc9e6", -- current position = bright ice
  -- Chrome
  comment = "#647486",
  border = "#3a4756",
  cursor = "#85b8d9", -- ice cyan
  accent = "#85b8d9",
  -- Status / diagnostics
  error = "#d97a6f",
  warning = "#d9bd7a",
  info = "#85b8d9",
  hint = "#7d8b99",
  ok = "#9cc9b0",
  -- Git / VCS
  git_add = "#9cc9b0",
  git_change = "#d9bd7a",
  git_delete = "#d97a6f",
  diff_add = "#263832",
  diff_change = "#38332a",
  diff_delete = "#3a2a2a",
  diff_text = "#4c4530",
  -- Syntax (by role)
  s_keyword = "#85b8d9", -- ice cyan
  s_func = "#d9c291", -- pale brass
  s_string = "#9cc9b0", -- sea foam
  s_type = "#a5b3d9", -- periwinkle
  s_number = "#d9a98c",
  s_constant = "#e3d3a8",
  s_var = "#c3cfda",
  s_property = "#b0c2d4",
  s_param = "#c3cfda",
  s_operator = "#a5b3d9",
  s_tag = "#85b8d9",
  s_attribute = "#9cc9e6",
  s_constructor = "#d9c291",
  s_preproc = "#85b8d9",
  s_punct = "#93a1ae",
  s_title = "#d9a98c",
  s_special = "#d9a98c", -- regex / special chars
  s_escape = "#8595a3", -- string.escape, comment.doc
  s_builtin = "#d9a98c", -- variable.builtin / function.builtin
  s_namespace = "#c3cfda",
  s_label = "#9cc9e6",
  s_link = "#9cc9b0", -- link_uri
  s_link_text = "#d9c291",
  none = "NONE",
  -- Terminal ANSI
  terminal = {
    black = "#212b36",
    red = "#d97a6f",
    green = "#9cc9b0",
    yellow = "#d9bd7a",
    blue = "#85b8d9",
    magenta = "#b39ac4",
    cyan = "#8fc4c9",
    white = "#c3cfda",
    br_black = "#647486",
    br_red = "#e59183",
    br_green = "#b3dac4",
    br_yellow = "#e6cd8f",
    br_blue = "#9cc9e6",
    br_magenta = "#c7b0d6",
    br_cyan = "#a6d8dc",
    br_white = "#e8edf2",
  },
}

---@param variant string|nil variant name (one of the M[...] tables above)
function M.get_palette(variant)
  return M[variant] or M["one-dark"]
end

return M
