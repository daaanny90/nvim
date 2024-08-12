vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true -- Set highlight on search
vim.opt.mouse = 'a' -- Enable mouse mode
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner
vim.opt.termguicolors = true
vim.o.background = 'dark'

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true -- Show which line your cursor is on

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.smartindent = true -- insert indents automatically
vim.opt.tabstop = 2 -- number of spaces tabs count for
vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'de_de' }

-- do not show the tilde for blank lines
vim.opt.fillchars = 'eob: '
