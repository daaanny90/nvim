-- Zed colorscheme :: plugin highlight groups
-- Integrations for the plugins used in this LazyVim config.

local M = {}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

---@param p table palette
---@param opts table config
function M.setup(p, opts)
  opts = opts or {}
  local transparent = opts.transparent
  local bg = transparent and p.none or p.bg
  local bg_sidebar = transparent and p.none or p.bg_sidebar

  -- ===========================================================================
  -- GitSigns
  -- ===========================================================================
  hl("GitSignsAdd", { fg = p.git_add })
  hl("GitSignsChange", { fg = p.git_change })
  hl("GitSignsDelete", { fg = p.git_delete })
  hl("GitSignsAddNr", { fg = p.git_add })
  hl("GitSignsChangeNr", { fg = p.git_change })
  hl("GitSignsDeleteNr", { fg = p.git_delete })
  hl("GitSignsAddLn", { bg = p.diff_add })
  hl("GitSignsChangeLn", { bg = p.diff_change })
  hl("GitSignsDeleteLn", { bg = p.diff_delete })
  hl("GitSignsCurrentLineBlame", { fg = p.comment, italic = true })

  -- ===========================================================================
  -- Telescope
  -- ===========================================================================
  hl("TelescopeNormal", { fg = p.fg, bg = p.bg_float })
  hl("TelescopeBorder", { fg = p.border, bg = p.bg_float })
  hl("TelescopeTitle", { fg = p.accent, bold = true })
  hl("TelescopePromptNormal", { fg = p.fg, bg = p.bg_popup })
  hl("TelescopePromptBorder", { fg = p.bg_popup, bg = p.bg_popup })
  hl("TelescopePromptTitle", { fg = p.bg, bg = p.accent, bold = true })
  hl("TelescopePromptPrefix", { fg = p.accent })
  hl("TelescopePromptCounter", { fg = p.comment })
  hl("TelescopeResultsNormal", { fg = p.fg, bg = p.bg_float })
  hl("TelescopeResultsBorder", { fg = p.bg_float, bg = p.bg_float })
  hl("TelescopeResultsTitle", { fg = p.bg_float, bg = p.bg_float })
  hl("TelescopePreviewNormal", { fg = p.fg, bg = p.bg_float })
  hl("TelescopePreviewBorder", { fg = p.bg_float, bg = p.bg_float })
  hl("TelescopePreviewTitle", { fg = p.bg, bg = p.ok, bold = true })
  hl("TelescopeSelection", { fg = p.fg, bg = p.bg_selected })
  hl("TelescopeSelectionCaret", { fg = p.accent, bg = p.bg_selected })
  hl("TelescopeMatching", { fg = p.accent, bold = true })

  -- ===========================================================================
  -- Neo-tree
  -- ===========================================================================
  hl("NeoTreeNormal", { fg = p.fg_sidebar, bg = bg_sidebar })
  hl("NeoTreeNormalNC", { fg = p.fg_sidebar, bg = bg_sidebar })
  hl("NeoTreeWinSeparator", { fg = p.border, bg = bg_sidebar })
  hl("NeoTreeEndOfBuffer", { fg = bg_sidebar, bg = bg_sidebar })
  hl("NeoTreeRootName", { fg = p.accent, bold = true })
  hl("NeoTreeDirectoryName", { fg = p.fg_sidebar })
  hl("NeoTreeDirectoryIcon", { fg = p.accent })
  hl("NeoTreeFileName", { fg = p.fg_sidebar })
  hl("NeoTreeFileIcon", { fg = p.fg_sidebar })
  hl("NeoTreeIndentMarker", { fg = p.fg_gutter })
  hl("NeoTreeExpander", { fg = p.comment })
  hl("NeoTreeGitAdded", { fg = p.git_add })
  hl("NeoTreeGitModified", { fg = p.git_change })
  hl("NeoTreeGitDeleted", { fg = p.git_delete })
  hl("NeoTreeGitUntracked", { fg = p.s_keyword })
  hl("NeoTreeGitIgnored", { fg = p.comment })
  hl("NeoTreeDimText", { fg = p.fg_gutter })
  hl("NeoTreeTabActive", { fg = p.fg, bg = bg_sidebar, bold = true })
  hl("NeoTreeTabInactive", { fg = p.comment, bg = p.bg_dark })
  hl("NeoTreeTabSeparatorActive", { fg = bg_sidebar, bg = bg_sidebar })
  hl("NeoTreeTabSeparatorInactive", { fg = p.bg_dark, bg = p.bg_dark })

  -- ===========================================================================
  -- nvim-tree (in case it is ever used)
  -- ===========================================================================
  hl("NvimTreeNormal", { fg = p.fg_sidebar, bg = bg_sidebar })
  hl("NvimTreeRootFolder", { fg = p.accent, bold = true })
  hl("NvimTreeFolderIcon", { fg = p.accent })
  hl("NvimTreeIndentMarker", { fg = p.fg_gutter })
  hl("NvimTreeGitDirty", { fg = p.git_change })
  hl("NvimTreeGitNew", { fg = p.git_add })
  hl("NvimTreeGitDeleted", { fg = p.git_delete })

  -- ===========================================================================
  -- nvim-cmp
  -- ===========================================================================
  hl("CmpItemAbbr", { fg = p.fg })
  hl("CmpItemAbbrDeprecated", { fg = p.comment, strikethrough = true })
  hl("CmpItemAbbrMatch", { fg = p.accent, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.accent, bold = true })
  hl("CmpItemMenu", { fg = p.comment })
  hl("CmpItemKindText", { fg = p.fg })
  hl("CmpItemKindFunction", { fg = p.s_func })
  hl("CmpItemKindMethod", { fg = p.s_func })
  hl("CmpItemKindVariable", { fg = p.s_var })
  hl("CmpItemKindKeyword", { fg = p.s_keyword })
  hl("CmpItemKindClass", { fg = p.s_type })
  hl("CmpItemKindInterface", { fg = p.s_type })
  hl("CmpItemKindConstant", { fg = p.s_constant })
  hl("CmpItemKindProperty", { fg = p.s_property })
  hl("CmpItemKindSnippet", { fg = p.s_special })

  -- ===========================================================================
  -- blink.cmp
  -- ===========================================================================
  hl("BlinkCmpMenu", { fg = p.fg, bg = p.bg_popup })
  hl("BlinkCmpMenuBorder", { fg = p.border, bg = p.bg_popup })
  hl("BlinkCmpMenuSelection", { bg = p.bg_selected })
  hl("BlinkCmpLabel", { fg = p.fg })
  hl("BlinkCmpLabelMatch", { fg = p.accent, bold = true })
  hl("BlinkCmpLabelDeprecated", { fg = p.comment, strikethrough = true })
  hl("BlinkCmpKind", { fg = p.accent })
  hl("BlinkCmpDoc", { fg = p.fg, bg = p.bg_float })
  hl("BlinkCmpDocBorder", { fg = p.border, bg = p.bg_float })
  hl("BlinkCmpGhostText", { fg = p.comment, italic = true })

  -- ===========================================================================
  -- Bufferline
  -- ===========================================================================
  hl("BufferLineFill", { bg = p.bg_dark })
  hl("BufferLineBackground", { fg = p.comment, bg = p.bg_dark })
  hl("BufferLineBufferVisible", { fg = p.fg_dark, bg = p.bg_dark })
  hl("BufferLineBufferSelected", { fg = p.fg, bg = bg, bold = true })
  hl("BufferLineSeparator", { fg = p.bg_dark, bg = p.bg_dark })
  hl("BufferLineSeparatorVisible", { fg = p.bg_dark, bg = p.bg_dark })
  hl("BufferLineSeparatorSelected", { fg = p.bg_dark, bg = bg })
  hl("BufferLineIndicatorSelected", { fg = p.accent, bg = bg })
  hl("BufferLineModified", { fg = p.git_change, bg = p.bg_dark })
  hl("BufferLineModifiedVisible", { fg = p.git_change, bg = p.bg_dark })
  hl("BufferLineModifiedSelected", { fg = p.git_change, bg = bg })
  hl("BufferLineCloseButtonSelected", { fg = p.error, bg = bg })
  hl("BufferLineNumbersSelected", { fg = p.fg, bg = bg, bold = true })
  hl("BufferLineDuplicateSelected", { fg = p.fg_dark, bg = bg, italic = true })

  -- ===========================================================================
  -- which-key
  -- ===========================================================================
  hl("WhichKey", { fg = p.accent })
  hl("WhichKeyGroup", { fg = p.s_keyword })
  hl("WhichKeyDesc", { fg = p.fg })
  hl("WhichKeySeparator", { fg = p.comment })
  hl("WhichKeyValue", { fg = p.fg_dark })
  hl("WhichKeyFloat", { bg = p.bg_float })
  hl("WhichKeyBorder", { fg = p.border, bg = p.bg_float })
  hl("WhichKeyTitle", { fg = p.accent, bg = p.bg_float, bold = true })

  -- ===========================================================================
  -- Indent-blankline (ibl)
  -- ===========================================================================
  hl("IblIndent", { fg = p.bg_highlight })
  hl("IblScope", { fg = p.fg_gutter })
  hl("IblWhitespace", { fg = p.bg_highlight })

  -- ===========================================================================
  -- Noice
  -- ===========================================================================
  hl("NoiceCmdline", { fg = p.fg, bg = p.bg_float })
  hl("NoiceCmdlinePopup", { fg = p.fg, bg = p.bg_float })
  hl("NoiceCmdlinePopupBorder", { fg = p.border, bg = p.bg_float })
  hl("NoiceCmdlineIcon", { fg = p.accent })
  hl("NoiceConfirmBorder", { fg = p.border, bg = p.bg_float })
  hl("NoicePopupBorder", { fg = p.border, bg = p.bg_float })
  hl("NoiceMini", { fg = p.fg_dark, bg = p.bg_float })

  -- ===========================================================================
  -- nvim-notify
  -- ===========================================================================
  hl("NotifyERRORBorder", { fg = p.error, bg = p.bg_float })
  hl("NotifyWARNBorder", { fg = p.warning, bg = p.bg_float })
  hl("NotifyINFOBorder", { fg = p.info, bg = p.bg_float })
  hl("NotifyDEBUGBorder", { fg = p.comment, bg = p.bg_float })
  hl("NotifyTRACEBorder", { fg = p.s_keyword, bg = p.bg_float })
  hl("NotifyERRORIcon", { fg = p.error })
  hl("NotifyWARNIcon", { fg = p.warning })
  hl("NotifyINFOIcon", { fg = p.info })
  hl("NotifyERRORTitle", { fg = p.error })
  hl("NotifyWARNTitle", { fg = p.warning })
  hl("NotifyINFOTitle", { fg = p.info })
  hl("NotifyBackground", { fg = p.fg, bg = p.bg_float })

  -- ===========================================================================
  -- Snacks (LazyVim default UI)
  -- ===========================================================================
  hl("SnacksNormal", { fg = p.fg, bg = p.bg_float })
  hl("SnacksWinBar", { fg = p.fg_dark, bg = p.bg_float })
  hl("SnacksBackdrop", { bg = p.bg_dark })
  hl("SnacksDashboardHeader", { fg = p.accent })
  hl("SnacksDashboardTitle", { fg = p.accent, bold = true })
  hl("SnacksDashboardDesc", { fg = p.fg })
  hl("SnacksDashboardKey", { fg = p.s_keyword })
  hl("SnacksDashboardIcon", { fg = p.s_number })
  hl("SnacksDashboardFooter", { fg = p.comment })
  hl("SnacksPickerListCursorLine", { bg = p.bg_selected })
  hl("SnacksPickerMatch", { fg = p.accent, bold = true })

  -- ===========================================================================
  -- Flash
  -- ===========================================================================
  hl("FlashBackdrop", { fg = p.comment })
  hl("FlashLabel", { fg = p.bg, bg = p.error, bold = true })
  hl("FlashMatch", { fg = p.bg, bg = p.accent })
  hl("FlashCurrent", { fg = p.bg, bg = p.warning })

  -- ===========================================================================
  -- mini.nvim
  -- ===========================================================================
  hl("MiniIndentscopeSymbol", { fg = p.fg_gutter })
  hl("MiniStatuslineModeNormal", { fg = p.bg, bg = p.accent, bold = true })
  hl("MiniStatuslineModeInsert", { fg = p.bg, bg = p.ok, bold = true })
  hl("MiniStatuslineModeVisual", { fg = p.bg, bg = p.s_keyword, bold = true })
  hl("MiniStatuslineFilename", { fg = p.fg_dark, bg = p.bg_float })
  hl("MiniIconsAzure", { fg = p.accent })
  hl("MiniIconsBlue", { fg = p.s_func })
  hl("MiniIconsCyan", { fg = p.s_type })
  hl("MiniIconsGreen", { fg = p.s_string })
  hl("MiniIconsGrey", { fg = p.fg_dark })
  hl("MiniIconsOrange", { fg = p.s_number })
  hl("MiniIconsPurple", { fg = p.s_keyword })
  hl("MiniIconsRed", { fg = p.error })
  hl("MiniIconsYellow", { fg = p.warning })

  -- ===========================================================================
  -- Trouble
  -- ===========================================================================
  hl("TroubleNormal", { fg = p.fg, bg = bg_sidebar })
  hl("TroubleText", { fg = p.fg })
  hl("TroubleCount", { fg = p.accent, bg = p.bg_selected })
  hl("TroubleNormalNC", { fg = p.fg, bg = bg_sidebar })

  -- ===========================================================================
  -- Todo-comments
  -- ===========================================================================
  hl("TodoBgTODO", { fg = p.bg, bg = p.info, bold = true })
  hl("TodoBgFIX", { fg = p.bg, bg = p.error, bold = true })
  hl("TodoBgWARN", { fg = p.bg, bg = p.warning, bold = true })
  hl("TodoBgNOTE", { fg = p.bg, bg = p.hint, bold = true })
  hl("TodoFgTODO", { fg = p.info })
  hl("TodoFgFIX", { fg = p.error })
  hl("TodoFgWARN", { fg = p.warning })
  hl("TodoFgNOTE", { fg = p.hint })

  -- ===========================================================================
  -- Lazy / Mason
  -- ===========================================================================
  hl("LazyNormal", { fg = p.fg, bg = p.bg_float })
  hl("LazyButton", { fg = p.fg, bg = p.bg_selected })
  hl("LazyButtonActive", { fg = p.bg, bg = p.accent, bold = true })
  hl("LazyH1", { fg = p.bg, bg = p.accent, bold = true })
  hl("LazyProgressDone", { fg = p.ok })
  hl("LazyProgressTodo", { fg = p.fg_gutter })
  hl("MasonNormal", { fg = p.fg, bg = p.bg_float })
  hl("MasonHeader", { fg = p.bg, bg = p.accent, bold = true })
  hl("MasonHighlight", { fg = p.accent })
  hl("MasonMuted", { fg = p.comment })
  hl("MasonMutedBlock", { fg = p.fg_dark, bg = p.bg_selected })

  -- ===========================================================================
  -- Misc: dap, rainbow-delimiters, illuminate
  -- ===========================================================================
  hl("DapStoppedLine", { bg = p.diff_change })
  hl("RainbowDelimiterRed", { fg = p.error })
  hl("RainbowDelimiterYellow", { fg = p.warning })
  hl("RainbowDelimiterBlue", { fg = p.s_func })
  hl("RainbowDelimiterOrange", { fg = p.s_number })
  hl("RainbowDelimiterGreen", { fg = p.s_string })
  hl("RainbowDelimiterViolet", { fg = p.s_keyword })
  hl("RainbowDelimiterCyan", { fg = p.s_type })
  hl("IlluminatedWordText", { bg = p.bg_selected })
  hl("IlluminatedWordRead", { bg = p.bg_selected })
  hl("IlluminatedWordWrite", { bg = p.bg_selected })

  return M
end

return M
