-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
}

vim.lsp.enable("ts_ls")
