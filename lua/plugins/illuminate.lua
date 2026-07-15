-- highlight other occurrences of the symbol under the cursor (LSP-aware)
return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      delay = 200,
      large_file_cutoff = 2000, -- disable on huge files
      providers = { "lsp", "treesitter", "regex" },
    })
  end,
}
