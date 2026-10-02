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
        -- Less gutter noise inside diff windows. Go through diffview's own
        -- Window:use_winopts() instead of vim.wo[winid]: diffview saves the
        -- original values and restores them when the file is unloaded. Setting
        -- the options directly leaks them into Neovim's per-buffer window-option
        -- memory (see :h local-options), so a file reviewed in diffview would
        -- later reopen in a normal window with 'relativenumber' off.
        local view = require("diffview.lib").get_current_view()
        local windows = view and view.cur_layout and view.cur_layout.windows or {}
        for _, win in ipairs(windows) do
          if win.id == winid then
            win:use_winopts({ foldcolumn = "0", relativenumber = false })
            break
          end
        end
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
