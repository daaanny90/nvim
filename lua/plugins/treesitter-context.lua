-- keep the enclosing function/component signature pinned at the top while scrolling
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    max_lines = 4, -- cap the pinned block height
    multiline_threshold = 2,
  },
}
