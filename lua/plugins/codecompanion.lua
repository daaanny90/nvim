return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    init = function()
      -- Pre-flight: when the chat opens with Ollama down, show a friendly notice.
      -- (CodeCompanion itself only surfaces an error *after* you submit a message.)
      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionChatOpened",
        group = vim.api.nvim_create_augroup("codecompanion-ollama-check", { clear = true }),
        desc = "Warn if Ollama is down when opening the CodeCompanion chat",
        callback = function()
          require("localai").check_and_notify("CodeCompanion")
        end,
      })
    end,
    keys = {
      {
        "<leader>ai",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "Toggle local AI chat (ollama)",
      },
    },
    opts = {
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = { default = "qwen2.5-coder:7b" },
                num_ctx = { default = 16384 }, -- parameters.options — no turn truncation
                temperature = { default = 0.2 }, -- parameters.options — less rambling
                keep_alive = { default = "30m" }, -- parameters — no cold reload between chats
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = "ollama",
          opts = {
            -- Terser than CodeCompanion's default prompt: a local 7B tends to
            -- over-explain and re-dump whole files. Keep the code-block format.
            -- Path: user `strategies.chat.opts` is migrated to `interactions.chat.opts`.
            system_prompt = [[You are a coding assistant inside Neovim. Be terse and impersonal.
Output ONLY the minimal code change requested. Never repeat unchanged code — use a `...existing code...` comment. No preamble, no summary, no explanation unless explicitly asked.
When you output code, use fenced code blocks with the language and, in curly braces, the file path.]],
          },
        },
        inline = { adapter = "ollama" },
      },
      display = {
        chat = {
          window = {
            layout = "float",
            border = "rounded",
            width = 0.85,
            height = 0.85,
          },
        },
      },
    },
  },
}
