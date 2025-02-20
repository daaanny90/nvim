-- integrate lazydocker in neovim like lazygit
return {
  'crnvl96/lazydocker.nvim',
  event = 'VeryLazy',
  config = function()
    require('lazydocker').setup()

    vim.keymap.set('n', '<leader>dd', '<cmd>LazyDocker<cr>', { desc = 'Open Lazy [DD]ocker' })
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
