-- LSP - VOLAR
require('lspconfig').volar.setup {
  init_options = {
    vue = {
      hybridMode = true,
    },
  },
  filetypes = {
    'vue',
  },
  settings = {
    Vue = {
      completion = {
        defaultTagNameCase = 'kebabCase',
      },
    },
  },
}

-- LSP - ESLINT Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- LSP - TSSERVER
require('lspconfig').ts_ls.setup {
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = '/Users/dasp/.nvm/versions/node/v18.19.0/lib/node_modules/@vue/typescript-plugin',
        languages = {
          'javascript',
          'typescript',
          'vue',
        },
      },
    },
  },
  filetypes = {
    'typescript',
    'javascript',
    'vue',
  },
  single_file_support = false,
}

-- DAP - PHP XDEBUG
local dap = require 'dap'
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/Users/dasp/.config/nvim/lua/plugins/dap-adapters/vscode-php-debug/out/phpDebug.js' },
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
  },
}
