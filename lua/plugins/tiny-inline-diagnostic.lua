-- pretty inline diagnostics on the cursor line: severity-colored block with
-- long messages wrapped and indented (readable TS errors / test failures),
-- replacing the raw vim.diagnostic virtual_lines rendering
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    preset = "modern",
    options = {
      show_source = { enabled = false },
      multilines = { enabled = true }, -- also render diagnostics of other lines, compactly
      overflow = { mode = "wrap" },
      break_line = { enabled = false },
      enable_on_insert = false,
      enable_on_select = false,
    },
  },
}
