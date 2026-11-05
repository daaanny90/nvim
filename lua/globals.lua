vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- LSP
-- Self-contained: nvim-lspconfig (source of lsp/lua_ls.lua defaults) is lazy and not on the rtp here.
vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
vim.lsp.enable("lua_ls")
