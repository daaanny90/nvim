-- ============================================================================
-- COLORSCHEME SELECTION - Choose your colorscheme here!
-- Uncomment ONE line below to activate a colorscheme
-- ============================================================================

-- TOKYONIGHT variants
-- vim.cmd.colorscheme("tokyonight")
-- vim.cmd.colorscheme("tokyonight-night")
-- vim.cmd.colorscheme("tokyonight-storm")
-- vim.cmd.colorscheme("tokyonight-moon")
-- vim.cmd.colorscheme("tokyonight-day")

-- MOONFLY
-- vim.cmd.colorscheme("moonfly")

-- NIGHTFOX variants
-- vim.cmd.colorscheme("carbonfox")
-- vim.cmd.colorscheme("nightfox")
-- vim.cmd.colorscheme("dawnfox")
-- vim.cmd.colorscheme("duskfox")
-- vim.cmd.colorscheme("nordfox")
-- vim.cmd.colorscheme("terafox")

-- DRACULA
-- vim.cmd.colorscheme("dracula")

-- VSCODE
-- vim.cmd.colorscheme("vscode")

-- SONOKAI
-- vim.cmd.colorscheme("sonokai")

-- ONEDARK
-- vim.cmd.colorscheme("onedark")

-- NORDIC
-- vim.cmd.colorscheme("nordic")

-- NORD
-- vim.cmd.colorscheme("nord")

-- GITHUB variants
-- vim.cmd.colorscheme("github_dark")
-- vim.cmd.colorscheme("github_dark_default")
-- vim.cmd.colorscheme("github_dark_dimmed")
-- vim.cmd.colorscheme("github_light")

-- OXOCARBON
-- vim.cmd.colorscheme("oxocarbon")

-- ROSE PINE variants
-- vim.cmd.colorscheme("rose-pine")
-- vim.cmd.colorscheme("rose-pine-main")
-- vim.cmd.colorscheme("rose-pine-moon")
-- vim.cmd.colorscheme("rose-pine-dawn")

-- LACKLUSTER variants
-- vim.cmd.colorscheme("lackluster")
-- vim.cmd.colorscheme("lackluster-hack")
-- vim.cmd.colorscheme("lackluster-mint")

-- YUGEN
-- vim.cmd.colorscheme("yugen")

-- XCODE variants
-- vim.cmd.colorscheme("xcode")
-- vim.cmd.colorscheme("xcodedark")
-- vim.cmd.colorscheme("xcodedarkhc")
-- vim.cmd.colorscheme("xcodehc")
-- vim.cmd.colorscheme("xcodelight")
-- vim.cmd.colorscheme("xcodelighthc")
-- vim.cmd.colorscheme("xcodewwdc")

-- ENFOCADO
-- vim.cmd.colorscheme("enfocado")

-- CATPPUCCIN variants
-- vim.cmd.colorscheme("catppuccin")
-- vim.cmd.colorscheme("catppuccin-latte")
-- vim.cmd.colorscheme("catppuccin-frappe")
-- vim.cmd.colorscheme("catppuccin-macchiato")
-- vim.cmd.colorscheme("catppuccin-mocha")

-- SOLARIZED OSAKA variants
-- vim.cmd.colorscheme("solarized-osaka")
-- vim.cmd.colorscheme("solarized-osaka-night")
-- vim.cmd.colorscheme("solarized-osaka-storm")
-- vim.cmd.colorscheme("solarized-osaka-day")

-- KANAGAWA variants
-- vim.cmd.colorscheme("kanagawa")
-- vim.cmd.colorscheme("kanagawa-wave")
vim.cmd.colorscheme("kanagawa-dragon")
-- vim.cmd.colorscheme("kanagawa-lotus")

-- ============================================================================
-- Custom highlight overrides
-- ============================================================================

-- Function to apply custom highlights (removes backgrounds from sign columns)
local function apply_custom_highlights()
  -- Remove background from line numbers and sign column
  vim.cmd.hi("LineNr guibg=NONE ctermbg=NONE")
  vim.cmd.hi("SignColumn guibg=NONE ctermbg=NONE")
  vim.cmd.hi("CursorLineNr guibg=NONE ctermbg=NONE")

  -- Remove background from GitSigns column (but keep the symbol colors)
  vim.cmd([[highlight GitSignsAdd guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight GitSignsChange guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight GitSignsDelete guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight GitSignsAddNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight GitSignsChangeNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight GitSignsDeleteNr guibg=NONE ctermbg=NONE]])

  -- Also handle diagnostic signs in the sign column
  vim.cmd([[highlight DiagnosticSignError guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight DiagnosticSignWarn guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight DiagnosticSignInfo guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight DiagnosticSignHint guibg=NONE ctermbg=NONE]])
end

-- Apply highlights now
apply_custom_highlights()

-- Reapply highlights after colorscheme changes (to make sure they persist)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_custom_highlights,
})

-- Other custom highlights (optional)
-- vim.cmd.hi("Comment gui=none")
