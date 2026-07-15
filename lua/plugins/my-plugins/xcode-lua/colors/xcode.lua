-- Xcode Colorscheme (auto-detect based on vim.o.background)
-- Defaults to dark if background is not set

local style = vim.o.background == "light" and "light" or "dark"
require("xcode").load(style)
