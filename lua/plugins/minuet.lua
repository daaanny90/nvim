return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 2048,
        provider_options = {
          openai_fim_compatible = {
            -- minuet expects the name of a non-empty env var; ollama needs no
            -- API key, so any always-present var works
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:7b",
            optional = {
              max_tokens = 64,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          keymap = {
            accept = "<A-y>",
            accept_line = "<A-l>",
            dismiss = "<A-e>",
            next = "<A-]>",
            prev = "<A-[>",
          },
        },
      })

      vim.keymap.set("n", "<leader>um", "<cmd>Minuet virtualtext toggle<cr>",
        { desc = "Toggle Minuet completion" })
    end,
  },
  {
    -- statusline spinner while a completion request is in flight
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, require("minuet.lualine"))
    end,
  },
}
