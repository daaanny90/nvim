-- http client for neovim
return {
  'mistweaverco/kulala.nvim',
  config = function()
    -- Setup is required, even if you don't pass any options
    require('kulala').setup()

    vim.keymap.set('n', '<leader>ks', ':lua require("kulala").scratchpad()<CR>', { desc = 'Open [K]ulala [S]cratchpad' })
    vim.keymap.set('n', '<leader>kr', ':lua require("kulala").run()<CR>', { desc = '[R]un the current request' })
  end,
}
