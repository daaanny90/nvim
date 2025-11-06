require("lspconfig").ts_ls.setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").jsonls.setup({
  capabilities = capabilities,
  filetypes = { "json", "jsonc" },
  settings = { -- nota: 'settings' invece di 'json' direttamente
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
})

-- EslintFixAll on save through eslint_d and conform stopped working for now reason
-- this fixes the problem. Configuration in conform is still on autosave = true
-- let's see if this can create problems in future
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.vue" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
})
