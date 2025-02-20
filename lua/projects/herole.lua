-- LSP - VOLAR
require("lspconfig").volar.setup({
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
  filetypes = {
    "vue",
  },
  settings = {
    Vue = {
      completion = {
        defaultTagNameCase = "kebabCase",
      },
    },
  },
})

-- LSP - TSSERVER
require("lspconfig").ts_ls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Importa le capabilities di nvim-cmp
  root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git"),
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/Users/dasp/.nvm/versions/node/v18.19.0/lib/node_modules/@vue/typescript-plugin",
        languages = {
          "javascript",
          "typescript",
          "vue",
        },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "vue",
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

-- DAP - PHP XDEBUG
-- FIXME: not working at all. Server goes up but debug breakpoints don't work
-- probably the problem is that the backend is running in a docker container, but the
-- pathMapping did not work as expected 🤷
local dap = require("dap")
dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { "/Users/dasp/.config/nvim/lua/plugins/dap-adapters/vscode-php-debug/out/phpDebug.js" },
}

dap.configurations.php = {
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug",
    port = 9003,
    pathMappings = {
      ["/var/www/html"] = "${workspaceFolder}/website",
    },
  },
}

-- VIM TEST
-- somehow vim test do not recognize vitest out of the box. This fix the problem
vim.g["test#javascript#runner"] = "vitest"
