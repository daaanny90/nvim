return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  config = function()
    vim.keymap.set("n", "<leader>sr", ":GrugFar<cr>", { desc = "[S]earch [R]eplace" })
  end,
}

-- return {
--   "nvim-pack/nvim-spectre",
--   config = function()
--     vim.keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").toggle()<CR>', {
--       desc = "Toggle Spectre",
--     })
--   end,
-- }
