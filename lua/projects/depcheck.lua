require('lspconfig').ts_ls.setup {}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').jsonls.setup {
  capabilities = capabilities,
  filetypes = { 'json', 'jsonc' },
  settings = { -- nota: 'settings' invece di 'json' direttamente
    json = {
      schemas = {
        {
          fileMatch = { 'package.json' },
          url = 'https://json.schemastore.org/package.json',
        },
        {
          fileMatch = { 'tsconfig*.json' },
          url = 'https://json.schemastore.org/tsconfig.json',
        },
      },
      validate = { enable = true },
    },
  },
}
