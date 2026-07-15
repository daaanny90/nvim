-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure TypeScript Language Server
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
}
-- vim.lsp.enable("ts_ls")  -- DISABLED: replaced by typescript-tools.nvim (uncomment to revert)

-- Configure ESLint LSP for linting
vim.lsp.config.eslint = {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc", "eslint.config.js", "package.json", ".git" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Create EslintFixAll command for manual use (optional)
    vim.api.nvim_buf_create_user_command(bufnr, "EslintFixAll", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.fixAll.eslint" },
          diagnostics = {},
        },
        apply = true,
      })
    end, {
      desc = "Fix all ESLint problems",
    })
  end,
  settings = {
    -- Formatting is handled by conform.nvim
    format = false,
    -- Enable linting/validation
    validate = "on",
    -- Automatically run lint after file save
    run = "onType",
    -- Working directory settings
    workingDirectory = { mode = "auto" },
    -- Enable code actions
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
    -- Experimental features
    experimental = {
      useFlatConfig = false,
    },

    nodePath = "",
    problems = {},
    rulesCustomizations = {},
  },
}
vim.lsp.enable("eslint")

-- Configure Emmet Language Server
vim.lsp.config.emmet_language_server = {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "sass", "less", "vue", "javascriptreact", "typescriptreact" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
}
vim.lsp.enable("emmet_language_server")
