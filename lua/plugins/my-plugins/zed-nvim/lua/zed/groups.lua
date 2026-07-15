-- Zed colorscheme :: core highlight groups
-- Editor UI, traditional syntax, Treesitter, LSP semantic tokens, diagnostics.

local M = {}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

---@param p table palette
---@param opts table config
function M.setup(p, opts)
  opts = opts or {}
  local transparent = opts.transparent
  local italic_comments = opts.italic_comments ~= false
  local bold_keywords = opts.bold_keywords == true

  local bg = transparent and p.none or p.bg
  local bg_sidebar = transparent and p.none or p.bg_sidebar
  local bg_statusline = transparent and p.none or p.bg_statusline

  -- ===========================================================================
  -- Editor UI
  -- ===========================================================================
  hl("Normal", { fg = p.fg, bg = bg })
  hl("NormalNC", { fg = p.fg, bg = bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg_float })
  hl("FloatBorder", { fg = p.border, bg = p.bg_float })
  hl("FloatTitle", { fg = p.accent, bg = p.bg_float, bold = true })
  hl("ColorColumn", { bg = p.bg_highlight })
  hl("Conceal", { fg = p.comment })
  hl("Cursor", { fg = p.bg, bg = p.cursor })
  hl("lCursor", { fg = p.bg, bg = p.cursor })
  hl("CursorIM", { fg = p.bg, bg = p.cursor })
  hl("CursorLine", { bg = p.bg_highlight })
  hl("CursorColumn", { bg = p.bg_highlight })
  hl("LineNr", { fg = p.fg_gutter })
  hl("LineNrAbove", { fg = p.fg_gutter })
  hl("LineNrBelow", { fg = p.fg_gutter })
  hl("CursorLineNr", { fg = p.fg_active_nr, bold = true })
  hl("SignColumn", { fg = p.fg_gutter, bg = bg })
  hl("FoldColumn", { fg = p.fg_gutter, bg = bg })
  hl("Folded", { fg = p.comment, bg = p.bg_float })
  hl("CursorLineFold", { fg = p.fg_gutter })
  hl("CursorLineSign", { fg = p.fg_gutter })

  hl("VertSplit", { fg = p.border })
  hl("WinSeparator", { fg = p.border })
  hl("EndOfBuffer", { fg = bg })
  hl("NonText", { fg = p.fg_gutter })
  hl("SpecialKey", { fg = p.fg_gutter })
  hl("Whitespace", { fg = p.fg_gutter })

  hl("Visual", { bg = p.bg_visual })
  hl("VisualNOS", { bg = p.bg_visual })
  hl("Search", { fg = p.bg, bg = p.warning })
  hl("IncSearch", { fg = p.bg, bg = p.accent })
  hl("CurSearch", { fg = p.bg, bg = p.accent })
  hl("Substitute", { fg = p.bg, bg = p.error })
  hl("MatchParen", { fg = p.accent, bg = p.bg_selected, bold = true })

  hl("Pmenu", { fg = p.fg, bg = p.bg_popup })
  hl("PmenuSel", { fg = p.fg, bg = p.bg_selected })
  hl("PmenuKind", { fg = p.accent, bg = p.bg_popup })
  hl("PmenuKindSel", { fg = p.accent, bg = p.bg_selected })
  hl("PmenuExtra", { fg = p.fg_dark, bg = p.bg_popup })
  hl("PmenuExtraSel", { fg = p.fg_dark, bg = p.bg_selected })
  hl("PmenuSbar", { bg = p.bg_float })
  hl("PmenuThumb", { bg = p.border })
  hl("WildMenu", { fg = p.bg, bg = p.accent })

  hl("StatusLine", { fg = p.fg_dark, bg = bg_statusline })
  hl("StatusLineNC", { fg = p.comment, bg = bg_statusline })
  hl("TabLine", { fg = p.comment, bg = p.bg_dark })
  hl("TabLineFill", { bg = p.bg_dark })
  hl("TabLineSel", { fg = p.fg, bg = bg })
  hl("WinBar", { fg = p.fg_dark, bg = bg })
  hl("WinBarNC", { fg = p.comment, bg = bg })

  hl("Title", { fg = p.accent, bold = true })
  hl("Directory", { fg = p.accent })
  hl("Question", { fg = p.ok })
  hl("MoreMsg", { fg = p.ok })
  hl("ModeMsg", { fg = p.fg_dark, bold = true })
  hl("MsgArea", { fg = p.fg })
  hl("ErrorMsg", { fg = p.error })
  hl("WarningMsg", { fg = p.warning })
  hl("QuickFixLine", { bg = p.bg_selected, bold = true })
  hl("qfLineNr", { fg = p.fg_gutter })
  hl("qfFileName", { fg = p.accent })

  hl("DiffAdd", { bg = p.diff_add })
  hl("DiffChange", { bg = p.diff_change })
  hl("DiffDelete", { bg = p.diff_delete })
  hl("DiffText", { bg = p.diff_text })

  hl("SpellBad", { sp = p.error, undercurl = true })
  hl("SpellCap", { sp = p.warning, undercurl = true })
  hl("SpellLocal", { sp = p.info, undercurl = true })
  hl("SpellRare", { sp = p.hint, undercurl = true })

  hl("Added", { fg = p.git_add })
  hl("Changed", { fg = p.git_change })
  hl("Removed", { fg = p.git_delete })

  -- ===========================================================================
  -- Traditional syntax groups
  -- ===========================================================================
  hl("Comment", { fg = p.comment, italic = italic_comments })
  hl("SpecialComment", { fg = p.s_escape, italic = italic_comments })
  hl("Todo", { fg = p.bg, bg = p.warning, bold = true })

  hl("Constant", { fg = p.s_constant })
  hl("String", { fg = p.s_string })
  hl("Character", { fg = p.s_string })
  hl("Number", { fg = p.s_number })
  hl("Float", { fg = p.s_number })
  hl("Boolean", { fg = p.s_number })

  hl("Identifier", { fg = p.s_var })
  hl("Function", { fg = p.s_func })

  hl("Statement", { fg = p.s_keyword, bold = bold_keywords })
  hl("Conditional", { fg = p.s_keyword, bold = bold_keywords })
  hl("Repeat", { fg = p.s_keyword, bold = bold_keywords })
  hl("Label", { fg = p.s_label })
  hl("Operator", { fg = p.s_operator })
  hl("Keyword", { fg = p.s_keyword, bold = bold_keywords })
  hl("Exception", { fg = p.s_keyword, bold = bold_keywords })

  hl("PreProc", { fg = p.s_preproc })
  hl("Include", { fg = p.s_preproc })
  hl("Define", { fg = p.s_preproc })
  hl("Macro", { fg = p.s_preproc })
  hl("PreCondit", { fg = p.s_preproc })

  hl("Type", { fg = p.s_type })
  hl("StorageClass", { fg = p.s_keyword })
  hl("Structure", { fg = p.s_type })
  hl("Typedef", { fg = p.s_type })

  hl("Special", { fg = p.s_special })
  hl("SpecialChar", { fg = p.s_special })
  hl("Tag", { fg = p.s_tag })
  hl("Delimiter", { fg = p.s_punct })
  hl("Debug", { fg = p.s_special })

  hl("Underlined", { fg = p.s_link, underline = true })
  hl("Bold", { bold = true })
  hl("Italic", { italic = true })
  hl("Ignore", { fg = p.comment })
  hl("Error", { fg = p.error })

  -- ===========================================================================
  -- Treesitter
  -- ===========================================================================
  hl("@comment", { link = "Comment" })
  hl("@comment.documentation", { fg = p.s_escape, italic = italic_comments })
  hl("@comment.error", { fg = p.error })
  hl("@comment.warning", { fg = p.warning })
  hl("@comment.todo", { fg = p.bg, bg = p.info, bold = true })
  hl("@comment.note", { fg = p.bg, bg = p.hint, bold = true })

  hl("@variable", { fg = p.s_var })
  hl("@variable.builtin", { fg = p.s_builtin })
  hl("@variable.parameter", { fg = p.s_param })
  hl("@variable.member", { fg = p.s_property })

  hl("@constant", { fg = p.s_constant })
  hl("@constant.builtin", { fg = p.s_number })
  hl("@constant.macro", { fg = p.s_preproc })

  hl("@module", { fg = p.s_namespace })
  hl("@namespace", { fg = p.s_namespace })
  hl("@label", { fg = p.s_label })

  hl("@string", { fg = p.s_string })
  hl("@string.documentation", { fg = p.s_string })
  hl("@string.regexp", { fg = p.s_special })
  hl("@string.escape", { fg = p.s_escape })
  hl("@string.special", { fg = p.s_special })
  hl("@string.special.symbol", { fg = p.s_special })
  hl("@string.special.url", { fg = p.s_link, underline = true })
  hl("@character", { fg = p.s_string })
  hl("@character.special", { fg = p.s_special })

  hl("@boolean", { fg = p.s_number })
  hl("@number", { fg = p.s_number })
  hl("@number.float", { fg = p.s_number })

  hl("@type", { fg = p.s_type })
  hl("@type.builtin", { fg = p.s_type })
  hl("@type.definition", { fg = p.s_type })
  hl("@attribute", { fg = p.s_attribute })
  hl("@property", { fg = p.s_property })

  hl("@function", { fg = p.s_func })
  hl("@function.builtin", { fg = p.s_builtin })
  hl("@function.call", { fg = p.s_func })
  hl("@function.macro", { fg = p.s_preproc })
  hl("@function.method", { fg = p.s_func })
  hl("@function.method.call", { fg = p.s_func })
  hl("@constructor", { fg = p.s_constructor })

  hl("@operator", { fg = p.s_operator })

  hl("@keyword", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.function", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.operator", { fg = p.s_keyword })
  hl("@keyword.import", { fg = p.s_preproc })
  hl("@keyword.return", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.conditional", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.repeat", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.exception", { fg = p.s_keyword, bold = bold_keywords })
  hl("@keyword.directive", { fg = p.s_preproc })

  hl("@punctuation.delimiter", { fg = p.s_punct })
  hl("@punctuation.bracket", { fg = p.s_punct })
  hl("@punctuation.special", { fg = p.s_special })

  hl("@tag", { fg = p.s_tag })
  hl("@tag.builtin", { fg = p.s_tag })
  hl("@tag.attribute", { fg = p.s_attribute })
  hl("@tag.delimiter", { fg = p.s_punct })

  -- Markup (markdown & friends)
  hl("@markup.heading", { fg = p.s_title, bold = true })
  hl("@markup.heading.1.markdown", { fg = p.s_title, bold = true })
  hl("@markup.heading.2.markdown", { fg = p.accent, bold = true })
  hl("@markup.heading.3.markdown", { fg = p.s_func, bold = true })
  hl("@markup.strong", { bold = true })
  hl("@markup.italic", { italic = true })
  hl("@markup.strikethrough", { strikethrough = true })
  hl("@markup.underline", { underline = true })
  hl("@markup.raw", { fg = p.s_string })
  hl("@markup.raw.block", { fg = p.s_string })
  hl("@markup.link", { fg = p.s_link_text })
  hl("@markup.link.label", { fg = p.s_link_text })
  hl("@markup.link.url", { fg = p.s_link, underline = true })
  hl("@markup.list", { fg = p.s_property })
  hl("@markup.quote", { fg = p.comment, italic = true })
  hl("@markup.math", { fg = p.s_number })

  hl("@diff.plus", { fg = p.git_add })
  hl("@diff.minus", { fg = p.git_delete })
  hl("@diff.delta", { fg = p.git_change })

  -- ===========================================================================
  -- LSP semantic tokens
  -- ===========================================================================
  hl("@lsp.type.namespace", { link = "@namespace" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.enum", { link = "@type" })
  hl("@lsp.type.interface", { link = "@type" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.typeParameter", { link = "@type" })
  hl("@lsp.type.parameter", { link = "@variable.parameter" })
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.macro", { link = "@function.macro" })
  hl("@lsp.type.decorator", { link = "@attribute" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.string", { link = "@string" })
  hl("@lsp.type.number", { link = "@number" })
  hl("@lsp.type.operator", { link = "@operator" })
  hl("@lsp.type.comment", { link = "@comment" })
  hl("@lsp.mod.readonly", { fg = p.s_constant })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.typemod.variable.readonly", { fg = p.s_constant })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })

  -- ===========================================================================
  -- Diagnostics
  -- ===========================================================================
  hl("DiagnosticError", { fg = p.error })
  hl("DiagnosticWarn", { fg = p.warning })
  hl("DiagnosticInfo", { fg = p.info })
  hl("DiagnosticHint", { fg = p.hint })
  hl("DiagnosticOk", { fg = p.ok })

  hl("DiagnosticVirtualTextError", { fg = p.error })
  hl("DiagnosticVirtualTextWarn", { fg = p.warning })
  hl("DiagnosticVirtualTextInfo", { fg = p.info })
  hl("DiagnosticVirtualTextHint", { fg = p.hint })

  hl("DiagnosticUnderlineError", { sp = p.error, undercurl = true })
  hl("DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
  hl("DiagnosticUnderlineInfo", { sp = p.info, undercurl = true })
  hl("DiagnosticUnderlineHint", { sp = p.hint, undercurl = true })

  hl("DiagnosticSignError", { fg = p.error })
  hl("DiagnosticSignWarn", { fg = p.warning })
  hl("DiagnosticSignInfo", { fg = p.info })
  hl("DiagnosticSignHint", { fg = p.hint })
  hl("DiagnosticUnnecessary", { fg = p.comment })
  hl("DiagnosticDeprecated", { fg = p.comment, strikethrough = true })

  -- ===========================================================================
  -- LSP
  -- ===========================================================================
  hl("LspReferenceText", { bg = p.bg_selected })
  hl("LspReferenceRead", { bg = p.bg_selected })
  hl("LspReferenceWrite", { bg = p.bg_selected })
  hl("LspSignatureActiveParameter", { fg = p.accent, bold = true })
  hl("LspCodeLens", { fg = p.comment })
  hl("LspInlayHint", { fg = p.comment, bg = p.bg_float })
  hl("LspInfoBorder", { fg = p.border, bg = p.bg_float })

  return M
end

return M
