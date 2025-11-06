return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    notify_no_formatters = true,
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'eslint_d' },
      javascript = { 'eslint_d' },
      javascriptreact = { 'prettier', 'eslint_d' },
      typescriptreact = { 'prettier', 'eslint_d' },
      vue = { 'eslint_d' },
      scss = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      astro = { 'prettier' },
    },
    format_on_save = function(bufnr)
      return {
        timeout_ms = 3000,
        lsp_fallback = false,
      }
    end,
    formatters = {
      prettier = {
        prepend_args = { '--single-quote' },
      },
    },
  },
}
