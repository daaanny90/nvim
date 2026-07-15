return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "grug-far",
      callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.bo[ev.buf].bufhidden = "wipe"
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, desc = "Close GrugFar" })
      end,
    })
  end,
  keys = {
    {
      "<leader>sr",
      function() require("grug-far").open() end,
      mode = "n",
      desc = "[S]earch [R]eplace",
    },
    {
      "<leader>sr",
      function() require("grug-far").with_visual_selection() end,
      mode = "v",
      desc = "[S]earch [R]eplace (selection)",
    },
    {
      "<leader>sW",
      function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
      mode = "n",
      desc = "[S]earch [W]ord replace",
    },
  },
}
