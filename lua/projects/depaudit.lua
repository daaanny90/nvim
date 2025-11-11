-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure TypeScript Language Server
vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
}

-- Configure JSON Language Server
vim.lsp.config["jsonls"] = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
      },
      validate = { enable = true },
    },
  },
}

-- Enable LSP servers
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")

-- EslintFixAll on save through eslint_d and conform stopped working for now reason
-- this fixes the problem. Configuration in conform is still on autosave = true
-- let's see if this can create problems in future
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.vue" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
})
