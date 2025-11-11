-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
}

-- Configure ESLint LSP for linting
vim.lsp.config["eslint"] = {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc", "eslint.config.js", "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    format = false,
    workingDirectory = { mode = "auto" },
  },
}

vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
