-- Mason - LSP Server Manager
-- This installs LSP servers, formatters, and linters
return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup({
      ui = { check_outdated_packages_on_open = true },
    })
  end,
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, { "eslint-lsp", "json-lsp", "yaml-language-server", "emmet-language-server", "css-lsp" })
  end,
}

