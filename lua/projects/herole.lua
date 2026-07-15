-- LSP Configuration using Neovim 11 native LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Vue Volar v3 setup: ts_ls handles script via @vue/typescript-plugin (loaded from @vue/language-server),
-- vue_ls handles template/style. No more hybridMode.
local vue_language_server_path =
  "/Users/dasp/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- vue_ls 3.x resolves TypeScript only via the --tsdk CLI flag (init_options.typescript.tsdk
-- is ignored); without it, the TS 7.x hoisted inside the mason package gets require()'d,
-- which has no ts.server export and crashes the server (exit 1).
local tsdk_path = "/Users/dasp/.nvm/versions/node/v20.20.0/lib/node_modules/typescript/lib"

-- Configure VUE Language Server (vue_ls replaces deprecated volar)
vim.lsp.config.vue_ls = {
  cmd = { "vue-language-server", "--stdio", "--tsdk=" .. tsdk_path },
  filetypes = { "vue" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  init_options = {
    typescript = {
      tsdk = tsdk_path,
    },
  },
  on_init = function(client)
    -- Vue v3 advertises definitionProvider but never responds for TS symbols;
    -- ts_ls + @vue/typescript-plugin handle these. Strip the capability so
    -- vim.lsp.buf.definition / Telescope don't wait on vue_ls.
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
  end,
}
vim.lsp.enable("vue_ls")

-- Configure JSON Language Server
vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
vim.lsp.enable("jsonls")

-- Configure YAML Language Server
vim.lsp.config.yamlls = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
    },
  },
}
vim.lsp.enable("yamlls")

-- Configure TypeScript Language Server — vue buffers only.
-- typescript-tools.nvim covers plain ts/js but can't pass languages=["vue"] to
-- @vue/typescript-plugin (its tsserver_plugins is a flat string list), so
-- tsserver never maps template positions and go-to-definition on component
-- tags returns nothing. ts_ls's init_options.plugins supports the full plugin
-- config, so ts_ls owns .vue while typescript-tools keeps the rest.
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
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

-- Configure Emmet Language Server
vim.lsp.config.emmet_language_server = {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "sass", "less", "vue", "javascriptreact", "typescriptreact" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
}
vim.lsp.enable("emmet_language_server")

-- Configure CSS Language Server (handles <style> blocks in .vue, plus css/scss/less standalone)
vim.lsp.config.cssls = {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less", "sass", "vue" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
vim.lsp.enable("cssls")

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

-- DAP - JS/VUE (Chrome against the herole Vite dev server)
-- Prepends the herole-specific launch config to the generic ones from
-- lua/plugins/dap.lua. Guarded by name: nvim-projectconfig re-sources this
-- file on every DirChanged, so a bare table.insert would duplicate entries.
local herole_chrome = {
  type = "pwa-chrome",
  request = "launch",
  name = "Chrome: herole Vite (localhost:8081, apps/vue)",
  url = "http://localhost:8081",
  webRoot = "${workspaceFolder}/apps/vue",
  sourceMaps = true,
  -- only Brave is installed; js-debug won't find Chrome on its own
  runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
}
for _, ft in ipairs({ "javascript", "typescript", "vue" }) do
  local configs = dap.configurations[ft] or {}
  local present = false
  for _, c in ipairs(configs) do
    if c.name == herole_chrome.name then
      present = true
      break
    end
  end
  if not present then
    table.insert(configs, 1, herole_chrome)
    dap.configurations[ft] = configs
  end
end

-- VIM TEST
-- somehow vim test do not recognize vitest out of the box. This fix the problem
vim.g["test#javascript#runner"] = "vitest"
