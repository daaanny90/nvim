-- edit the filesystem like a buffer: rename/create/delete files as text, :w applies
return {
  "stevearc/oil.nvim",
  lazy = false, -- recommended: lets `nvim <dir>` and dir-edits open oil directly
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
  },
  opts = {
    view_options = { show_hidden = true },
  },
}
