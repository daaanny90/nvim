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
  opts = {},
}
