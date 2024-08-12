return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({ '*' }, { hsl_fn = true })
  end,
}
