-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure VUE Language Server (vue_ls replaces deprecated volar)
vim.lsp.config["vue_ls"] = {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = "/Users/dasp/.nvm/versions/node/v18.19.0/lib/node_modules/typescript/lib",
    },
  },
}

-- Configure TypeScript Language Server  
vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/Users/dasp/.nvm/versions/node/v18.19.0/lib/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
}

-- Configure ESLint LSP for linting
vim.lsp.config["eslint"] = {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc", "eslint.config.js", "package.json", ".git" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  settings = {
    format = false, -- Use conform for formatting, not ESLint
    workingDirectory = { mode = "auto" },
  },
}

-- Enable LSP servers
vim.lsp.enable("vue_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")

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
