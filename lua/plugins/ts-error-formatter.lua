return {
  'dasp/ts-error-formatter.nvim',
  dev = true,
  enable = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('plugins.my-plugins.ts-error-formatter.ts-error-formatter').setup()
  end,
}
