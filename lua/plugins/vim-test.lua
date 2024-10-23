return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>', { desc = '[T]est [T]est Nearest' }),
  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [F]ile' }),
  vim.keymap.set('n', '<leader>ta', ':TestSuite<CR>', { desc = '[T]est [A]ll' }),
  vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = '[T]est [L]ast' }),
  vim.keymap.set('n', '<leader>tg', ':TestVisit<CR>', { desc = '[T]est [G]oto' }),

  -- open the test in a split panel at the bottom
  vim.cmd "let test#strategy = 'vimux'",
}
