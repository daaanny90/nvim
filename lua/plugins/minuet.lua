return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("localai").setup()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 4096,
        provider_options = {
          openai_fim_compatible = {
            -- minuet expects the name of a non-empty env var; ollama needs no
            -- API key, so any always-present var works
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            -- FIM needs a *base* model. The instruct tag (qwen2.5-coder:3b)
            -- replies with chat prose ("Certainly! ...") instead of completing.
            -- Keep it small (3b) for low ghost-text latency.
            model = "qwen2.5-coder:3b-base",
            optional = {
              max_tokens = 64,
              top_p = 0.9,
              temperature = 0.2,
              stop = { "\n\n" }, -- cut end-of-file over-generation at first blank line
            },
          },
        },
        -- Skip auto-completion (and warn once) when the local Ollama server is down,
        -- instead of spamming "Request failed with exit code 7" on every keystroke.
        -- The flag is refreshed on InsertEnter by localai.setup(); see lua/localai.lua.
        enable_predicates = {
          function()
            local ai = require("localai")
            if ai.up == false then
              ai.notify_down("minuet")
              return false
            end
            return true
          end,
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

      vim.keymap.set("n", "<leader>um", "<cmd>Minuet virtualtext toggle<cr>", { desc = "Toggle Minuet completion" })
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
