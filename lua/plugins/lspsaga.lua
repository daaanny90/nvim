-- improve the LSP experience

return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({})

    vim.keymap.set("n", "T", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "Show [T]ype definition in detail" })
    vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", { desc = "[C]ode [A]ction" })
    vim.keymap.set("n", "gf", "<cmd>Lspsaga finder<cr>", { desc = "Lspsa[G]a [F]inder" })
    vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Show [C]ode [D]iagnostic" })
    vim.keymap.set("n", "[n", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Show [N]ext diagnostic" })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  ft = { "lua", "vue", "typescript", "javascript", "php" },
}
