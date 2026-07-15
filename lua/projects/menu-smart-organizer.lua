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

-- vim.lsp.enable("ts_ls")  -- DISABLED: replaced by typescript-tools.nvim (uncomment to revert)
vim.lsp.enable("eslint")

-- Configure Emmet Language Server
vim.lsp.config.emmet_language_server = {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "sass", "less", "vue", "javascriptreact", "typescriptreact" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
}
vim.lsp.enable("emmet_language_server")
