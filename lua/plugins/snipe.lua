-- Quick buffer picker with letter hints
return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>bb",
      function() require("snipe").open_buffer_menu() end,
      desc = "Snipe buffer menu",
    },
  },
  opts = {
    ui = {
      position = "center",
      open_win_override = { border = "rounded" },
    },
    hints = {
      dictionary = "asdfgwertuiop",
    },
    navigate = {
      cancel_snipe = "q",
      close_buffer = "d",
      open_vsplit = "v",
      open_split = "x",
    },
    sort = "last",
  },
}
