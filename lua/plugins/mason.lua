-- Mason - LSP Server Manager
-- This installs LSP servers, formatters, and linters
return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
}

