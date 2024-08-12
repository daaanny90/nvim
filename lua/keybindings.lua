vim.keymap.set('i', 'kj', '<ESC>', { silent = true }) -- Escape with KJ

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear on pressing <Esc>

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show [D]iagnostic error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move uo or down the selected lines
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { silent = true })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- close current buffer
vim.keymap.set('n', '<leader>bd', function()
  require('bufdelete').bufwipeout(0, true)
end, { desc = 'Delete current buffer' })

vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' }) -- save file

vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'Open Mason' })

-- neogen: function documentation generation
local opts = { noremap = true, silent = true, desc = 'Generate function [D]ocumentation' }
vim.api.nvim_set_keymap('n', '<Leader>cD', ":lua require('neogen').generate()<CR>", opts)

-- http client kulala keybindings

