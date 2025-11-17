-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure VUE Language Server (vue_ls replaces deprecated volar)
vim.lsp.config.vue_ls = {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  init_options = {
    vue = {
      hybridMode = true,
    },
    typescript = {
      tsdk = "/Users/dasp/.nvm/versions/node/v18.19.0/lib/node_modules/typescript/lib",
    },
  },
}
vim.lsp.enable("vue_ls")

-- Configure TypeScript Language Server
vim.lsp.config.ts_ls = {
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
vim.lsp.enable("ts_ls")

-- Configure ESLint LSP for linting
vim.lsp.config.eslint = {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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
