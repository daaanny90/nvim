-- LSP Configuration for IoT-Plan (TypeScript/Nx monorepo)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure TypeScript Language Server
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_markers = { "tsconfig.json", "tsconfig.base.json", "package.json", ".git" },
  capabilities = capabilities,
}
-- vim.lsp.enable("ts_ls")  -- DISABLED: replaced by typescript-tools.nvim (uncomment to revert)

-- Configure JSON Language Server
vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", "tsconfig.json", "tsconfig.base.json", ".git" },
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
vim.lsp.enable("jsonls")

-- Configure ESLint LSP
vim.lsp.config.eslint = {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "eslint.config.mjs", "eslint.config.js", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    format = false,
    validate = "on",
    run = "onType",
    nodePath = vim.fn.getcwd() .. "/node_modules",
    workingDirectory = { directory = vim.fn.getcwd() },
    experimental = {
      useFlatConfig = true,
    },
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
