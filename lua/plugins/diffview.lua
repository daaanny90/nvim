-- side-by-side review of uncommitted changes and file history (PR-style view)
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    {
      "<leader>gd",
      function()
        if require("diffview.lib").get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Git [d]iff view (uncommitted changes)",
    },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git [h]istory of current file" },
  },
  opts = {
    enhanced_diff_hl = true, -- dim the filler areas, stronger hl on changed regions
    hooks = {
      diff_buf_win_enter = function(_, winid)
        -- less gutter noise inside diff windows
        vim.wo[winid].foldcolumn = "0"
        vim.wo[winid].relativenumber = false
      end,
    },
    keymaps = {
      -- q closes the whole view from anywhere, not only from the file panel
      view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
    },
  },
}
