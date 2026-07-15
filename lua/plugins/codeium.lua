return {
  "Exafunction/codeium.vim",
  event = "InsertEnter",
  config = function()
    vim.g.codeium_manual = true

    vim.keymap.set("i", "<M-TAB>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })

    vim.keymap.set("i", "<M-[>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })

    vim.keymap.set("i", "<M-]>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })

    vim.keymap.set("i", "<M-c>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })

    vim.keymap.set("i", "<M-\\>", function()
      return vim.fn["codeium#Complete"]()
    end, { expr = true, silent = true })
  end,
}
