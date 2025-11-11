-- ESLint LSP for JavaScript/TypeScript linting
-- This provides ESLint diagnostics through Neovim's native LSP
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "eslint-lsp" })
    end,
  },
}

