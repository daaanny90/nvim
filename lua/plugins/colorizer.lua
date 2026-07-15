return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({ '*', '!lazy', '!mason', '!neo-tree', '!toggleterm', '!TelescopePrompt' }, { hsl_fn = true })
  end,
}
