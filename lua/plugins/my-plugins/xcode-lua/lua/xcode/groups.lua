-- Xcode Highlight Groups
-- Defines all highlight groups for the colorscheme

local M = {}

-- Helper function to create highlight
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup(palette, opts)
  local p = palette
  local config = opts or {}

  -- Options
  local transparent = config.transparent or false
  local italic_comments = config.italic_comments ~= false
  local bold_keywords = config.bold_keywords == true -- Default to false for softer look

  -- Background handling for transparent mode
  local bg = transparent and p.none or p.bg
  local bg_sidebar = transparent and p.none or p.bg_sidebar
  local bg_float = transparent and p.none or p.bg_float

  -----------------------------------------------------------------------------
  -- Editor UI
  -----------------------------------------------------------------------------
  hl("Normal", { fg = p.fg, bg = bg })
  hl("NormalNC", { fg = p.fg, bg = bg })
  hl("NormalFloat", { fg = p.fg, bg = bg_float })
  hl("NormalSB", { fg = p.fg_sidebar, bg = bg_sidebar })
  hl("FloatBorder", { fg = p.border, bg = bg_float })
  hl("FloatTitle", { fg = p.fg_dark, bg = bg_float })

  -- Cursor
  hl("Cursor", { fg = p.bg, bg = p.cursor })
  hl("lCursor", { fg = p.bg, bg = p.cursor })
  hl("CursorIM", { fg = p.bg, bg = p.cursor })
  hl("CursorLine", { bg = p.bg_highlight })
  hl("CursorColumn", { bg = p.bg_highlight })
  hl("ColorColumn", { bg = p.bg_highlight })
  hl("TermCursor", { fg = p.bg, bg = p.cursor })
  hl("TermCursorNC", { fg = p.bg, bg = p.fg_gutter })

  -- Line numbers
  hl("LineNr", { fg = p.fg_gutter })
  hl("LineNrAbove", { fg = p.fg_gutter })
  hl("LineNrBelow", { fg = p.fg_gutter })
  hl("CursorLineNr", { fg = p.fg_dark })
  hl("CursorLineFold", { fg = p.fg_gutter })
  hl("CursorLineSign", { bg = p.bg_highlight })

  -- Sign column
  hl("SignColumn", { fg = p.fg_gutter, bg = bg })
  hl("SignColumnSB", { fg = p.fg_gutter, bg = bg_sidebar })
  hl("FoldColumn", { fg = p.fg_gutter })
  hl("Folded", { fg = p.comment, bg = p.bg_float })

  -- Search (softer, less harsh)
  hl("Search", { bg = p.bg_search })
  hl("IncSearch", { fg = p.bg, bg = p.orange })
  hl("CurSearch", { fg = p.bg, bg = p.orange })
  hl("Substitute", { bg = p.diff_delete })

  -- Visual
  hl("Visual", { bg = p.bg_visual })
  hl("VisualNOS", { bg = p.bg_visual })

  -- Statusline
  hl("StatusLine", { fg = p.fg, bg = p.bg_statusline })
  hl("StatusLineNC", { fg = p.fg_gutter, bg = p.bg_statusline })
  hl("WinBar", { fg = p.fg, bg = bg })
  hl("WinBarNC", { fg = p.fg_gutter, bg = bg })

  -- Tabline
  hl("TabLine", { fg = p.fg_gutter, bg = p.bg_statusline })
  hl("TabLineFill", { bg = p.bg_dark })
  hl("TabLineSel", { fg = p.fg, bg = p.bg_highlight, bold = true })

  -- Window
  hl("WinSeparator", { fg = p.border })
  hl("VertSplit", { fg = p.border })

  -- Popup menu
  hl("Pmenu", { fg = p.fg, bg = p.bg_popup })
  hl("PmenuSel", { fg = p.fg, bg = p.selection })
  hl("PmenuSbar", { bg = p.bg_popup })
  hl("PmenuThumb", { bg = p.fg_gutter })

  -- Messages
  hl("MsgArea", { fg = p.fg })
  hl("ModeMsg", { fg = p.fg, bold = true })
  hl("MoreMsg", { fg = p.cyan })
  hl("ErrorMsg", { fg = p.error })
  hl("WarningMsg", { fg = p.warning })
  hl("Question", { fg = p.cyan })

  -- Special
  hl("SpecialKey", { fg = p.fg_gutter })
  hl("NonText", { fg = p.fg_gutter })
  hl("EndOfBuffer", { fg = p.bg })
  hl("Whitespace", { fg = p.fg_gutter })
  hl("Directory", { fg = p.cyan })
  hl("Title", { fg = p.fg })
  hl("Conceal", { fg = p.comment })
  hl("MatchParen", { bg = p.bg_visual })

  -- Wildmenu
  hl("WildMenu", { fg = p.fg, bg = p.selection })

  -- Quickfix
  hl("QuickFixLine", { bg = p.bg_visual })
  hl("qfFileName", { fg = p.cyan })
  hl("qfLineNr", { fg = p.fg_gutter })

  -- Diff
  hl("DiffAdd", { bg = p.diff_add })
  hl("DiffChange", { bg = p.diff_change })
  hl("DiffDelete", { bg = p.diff_delete })
  hl("DiffText", { bg = p.diff_text })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = p.error })
  hl("SpellCap", { undercurl = true, sp = p.warning })
  hl("SpellLocal", { undercurl = true, sp = p.info })
  hl("SpellRare", { undercurl = true, sp = p.hint })

  -----------------------------------------------------------------------------
  -- Syntax (Traditional Vim)
  -----------------------------------------------------------------------------
  hl("Comment", { fg = p.comment, italic = italic_comments })
  hl("Constant", { fg = p.yellow })
  hl("String", { fg = p.red })
  hl("Character", { fg = p.yellow })
  hl("Number", { fg = p.yellow })
  hl("Boolean", { fg = p.pink, bold = bold_keywords })
  hl("Float", { fg = p.yellow })

  hl("Identifier", { fg = p.fg })
  hl("Function", { fg = p.purple })

  hl("Statement", { fg = p.pink, bold = bold_keywords })
  hl("Conditional", { fg = p.pink, bold = bold_keywords })
  hl("Repeat", { fg = p.pink, bold = bold_keywords })
  hl("Label", { fg = p.pink })
  hl("Operator", { fg = p.fg })
  hl("Keyword", { fg = p.pink, bold = bold_keywords })
  hl("Exception", { fg = p.pink, bold = bold_keywords })

  hl("PreProc", { fg = p.orange })
  hl("Include", { fg = p.pink, bold = bold_keywords })
  hl("Define", { fg = p.orange })
  hl("Macro", { fg = p.orange })
  hl("PreCondit", { fg = p.orange })

  hl("Type", { fg = p.cyan })
  hl("StorageClass", { fg = p.pink, bold = bold_keywords })
  hl("Structure", { fg = p.pink, bold = bold_keywords })
  hl("Typedef", { fg = p.cyan })

  hl("Special", { fg = p.orange })
  hl("SpecialChar", { fg = p.orange })
  hl("Tag", { fg = p.cyan })
  hl("Delimiter", { fg = p.fg_dark })
  hl("SpecialComment", { fg = p.comment, bold = true })
  hl("Debug", { fg = p.orange })

  hl("Underlined", { fg = p.cyan, underline = true })
  hl("Ignore", { fg = p.fg_gutter })
  hl("Error", { fg = p.error })
  hl("Todo", { fg = p.yellow, italic = true })

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  -- Identifiers
  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.pink })
  hl("@variable.parameter", { fg = p.fg })
  hl("@variable.member", { fg = p.green })

  -- Constants
  hl("@constant", { fg = p.yellow })
  hl("@constant.builtin", { fg = p.yellow })
  hl("@constant.macro", { fg = p.orange })

  -- Modules
  hl("@module", { fg = p.lavender })
  hl("@module.builtin", { fg = p.lavender })

  -- Strings
  hl("@string", { fg = p.red })
  hl("@string.documentation", { fg = p.comment })
  hl("@string.escape", { fg = p.orange })
  hl("@string.regexp", { fg = p.orange })
  hl("@string.special", { fg = p.orange })
  hl("@string.special.symbol", { fg = p.yellow })
  hl("@string.special.url", { fg = p.cyan, underline = true })

  -- Characters
  hl("@character", { fg = p.yellow })
  hl("@character.special", { fg = p.orange })

  -- Numbers
  hl("@number", { fg = p.yellow })
  hl("@number.float", { fg = p.yellow })

  -- Booleans
  hl("@boolean", { fg = p.pink, bold = bold_keywords })

  -- Types
  hl("@type", { fg = p.cyan })
  hl("@type.builtin", { fg = p.cyan })
  hl("@type.definition", { fg = p.lavender })
  hl("@type.qualifier", { fg = p.pink, bold = bold_keywords })

  -- Attributes
  hl("@attribute", { fg = p.orange })
  hl("@attribute.builtin", { fg = p.orange })

  -- Properties
  hl("@property", { fg = p.green })

  -- Functions
  hl("@function", { fg = p.purple })
  hl("@function.builtin", { fg = p.purple })
  hl("@function.call", { fg = p.purple })
  hl("@function.macro", { fg = p.orange })
  hl("@function.method", { fg = p.purple })
  hl("@function.method.call", { fg = p.purple })

  -- Constructors
  hl("@constructor", { fg = p.cyan })

  -- Operators
  hl("@operator", { fg = p.fg })

  -- Keywords
  hl("@keyword", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.conditional", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.conditional.ternary", { fg = p.pink })
  hl("@keyword.coroutine", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.debug", { fg = p.pink })
  hl("@keyword.directive", { fg = p.orange })
  hl("@keyword.directive.define", { fg = p.orange })
  hl("@keyword.exception", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.function", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.import", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.modifier", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.operator", { fg = p.pink })
  hl("@keyword.repeat", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.return", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.storage", { fg = p.pink, bold = bold_keywords })
  hl("@keyword.type", { fg = p.pink, bold = bold_keywords })

  -- Punctuation
  hl("@punctuation.bracket", { fg = p.fg_dark })
  hl("@punctuation.delimiter", { fg = p.fg_dark })
  hl("@punctuation.special", { fg = p.orange })

  -- Comments
  hl("@comment", { fg = p.comment, italic = italic_comments })
  hl("@comment.documentation", { fg = p.comment, italic = italic_comments })
  hl("@comment.error", { fg = p.error })
  hl("@comment.note", { fg = p.info })
  hl("@comment.todo", { fg = p.yellow, italic = true })
  hl("@comment.warning", { fg = p.warning })

  -- Markup (Markdown, etc.)
  hl("@markup.heading", { fg = p.fg })
  hl("@markup.heading.1", { fg = p.pink })
  hl("@markup.heading.2", { fg = p.purple })
  hl("@markup.heading.3", { fg = p.cyan })
  hl("@markup.heading.4", { fg = p.green })
  hl("@markup.heading.5", { fg = p.yellow })
  hl("@markup.heading.6", { fg = p.orange })
  hl("@markup.italic", { italic = true })
  hl("@markup.strong", { bold = true })
  hl("@markup.strikethrough", { strikethrough = true })
  hl("@markup.underline", { underline = true })
  hl("@markup.link", { fg = p.cyan })
  hl("@markup.link.label", { fg = p.cyan })
  hl("@markup.link.url", { fg = p.cyan, underline = true })
  hl("@markup.list", { fg = p.pink })
  hl("@markup.list.checked", { fg = p.green })
  hl("@markup.list.unchecked", { fg = p.fg_gutter })
  hl("@markup.quote", { fg = p.comment, italic = true })
  hl("@markup.math", { fg = p.yellow })
  hl("@markup.raw", { fg = p.green })
  hl("@markup.raw.block", { fg = p.green })

  -- Tags (HTML, JSX, etc.)
  hl("@tag", { fg = p.pink })
  hl("@tag.attribute", { fg = p.green })
  hl("@tag.builtin", { fg = p.pink })
  hl("@tag.delimiter", { fg = p.fg_dark })

  -- Diff
  hl("@diff.plus", { fg = p.git_add })
  hl("@diff.minus", { fg = p.git_delete })
  hl("@diff.delta", { fg = p.git_change })

  -----------------------------------------------------------------------------
  -- LSP Semantic Tokens
  -----------------------------------------------------------------------------
  hl("@lsp.type.class", { fg = p.cyan })
  hl("@lsp.type.comment", { fg = p.comment, italic = italic_comments })
  hl("@lsp.type.decorator", { fg = p.orange })
  hl("@lsp.type.enum", { fg = p.cyan })
  hl("@lsp.type.enumMember", { fg = p.yellow })
  hl("@lsp.type.function", { fg = p.purple })
  hl("@lsp.type.interface", { fg = p.lavender })
  hl("@lsp.type.keyword", { fg = p.pink, bold = bold_keywords })
  hl("@lsp.type.macro", { fg = p.orange })
  hl("@lsp.type.method", { fg = p.purple })
  hl("@lsp.type.namespace", { fg = p.lavender })
  hl("@lsp.type.number", { fg = p.yellow })
  hl("@lsp.type.operator", { fg = p.fg })
  hl("@lsp.type.parameter", { fg = p.fg })
  hl("@lsp.type.property", { fg = p.green })
  hl("@lsp.type.string", { fg = p.red })
  hl("@lsp.type.struct", { fg = p.cyan })
  hl("@lsp.type.type", { fg = p.cyan })
  hl("@lsp.type.typeParameter", { fg = p.lavender })
  hl("@lsp.type.variable", { fg = p.fg })

  hl("@lsp.mod.defaultLibrary", { fg = p.cyan })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.readonly", { italic = true })

  hl("@lsp.typemod.function.defaultLibrary", { fg = p.purple })
  hl("@lsp.typemod.method.defaultLibrary", { fg = p.purple })
  hl("@lsp.typemod.variable.defaultLibrary", { fg = p.cyan })

  -----------------------------------------------------------------------------
  -- Diagnostics
  -----------------------------------------------------------------------------
  hl("DiagnosticError", { fg = p.error })
  hl("DiagnosticWarn", { fg = p.warning })
  hl("DiagnosticInfo", { fg = p.info })
  hl("DiagnosticHint", { fg = p.hint })
  hl("DiagnosticOk", { fg = p.green })

  hl("DiagnosticSignError", { fg = p.error })
  hl("DiagnosticSignWarn", { fg = p.warning })
  hl("DiagnosticSignInfo", { fg = p.info })
  hl("DiagnosticSignHint", { fg = p.hint })
  hl("DiagnosticSignOk", { fg = p.green })

  hl("DiagnosticVirtualTextError", { fg = p.error, bg = p.diff_delete })
  hl("DiagnosticVirtualTextWarn", { fg = p.warning, bg = p.diff_change })
  hl("DiagnosticVirtualTextInfo", { fg = p.info })
  hl("DiagnosticVirtualTextHint", { fg = p.hint })
  hl("DiagnosticVirtualTextOk", { fg = p.green })

  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.error })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.warning })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.info })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.hint })
  hl("DiagnosticUnderlineOk", { undercurl = true, sp = p.green })

  hl("DiagnosticFloatingError", { fg = p.error })
  hl("DiagnosticFloatingWarn", { fg = p.warning })
  hl("DiagnosticFloatingInfo", { fg = p.info })
  hl("DiagnosticFloatingHint", { fg = p.hint })
  hl("DiagnosticFloatingOk", { fg = p.green })

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  hl("LspReferenceText", { bg = p.bg_visual })
  hl("LspReferenceRead", { bg = p.bg_visual })
  hl("LspReferenceWrite", { bg = p.bg_visual })
  hl("LspSignatureActiveParameter", { fg = p.orange, bold = true })
  hl("LspCodeLens", { fg = p.comment })
  hl("LspCodeLensSeparator", { fg = p.fg_gutter })
  hl("LspInlayHint", { fg = p.comment, bg = p.bg_highlight })

  return M
end

return M
