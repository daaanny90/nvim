-- typescript-tools.nvim - TS/JS LSP replacement for ts_ls
-- .vue buffers are NOT handled here: tsserver_plugins is a flat string list,
-- so @vue/typescript-plugin can't receive languages=["vue"] and tsserver never
-- maps template positions (go-to-definition on component tags returns nothing).
-- .vue is owned by ts_ls, enabled per-project with the full plugin config
-- (see lua/projects/herole.lua). The plugin below stays loaded so plain
-- .ts/.js files still resolve .vue imports.
-- To revert fully: delete this file (or set enabled = false) and uncomment
--   `vim.lsp.enable("ts_ls")` lines + restore filetypes in lua/projects/*.lua
return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  opts = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
    settings = {
      -- tsserver_plugins are resolved ONLY from `npm root -g` of the active node
      -- (no location override exists in this API). @vue/typescript-plugin is a
      -- symlink in the node 24 global node_modules pointing into mason's
      -- vue-language-server package, so its version always matches vue_ls.
      -- After `nvm alias default <new>`, recreate the symlink for that version.
      tsserver_plugins = {
        "@vue/typescript-plugin",
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      expose_as_code_action = "all",
      complete_function_calls = true,
    },
  },
  config = function(_, opts)
    require("typescript-tools").setup(opts)
  end,
}
