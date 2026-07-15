vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true -- Set highlight on search
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.pumheight = 12 -- Limit completion menu height
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 600 -- Wait for mapping completion (300 was too short: leader+p often triggered paste)
vim.opt.termguicolors = true
vim.o.background = "dark"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split" -- Preview substitutions live, as you type!

vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.smartindent = true -- insert indents automatically
vim.opt.tabstop = 2 -- number of spaces tabs count for
vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.spell = true
vim.opt.spelllang = { "en_us", "de_de" }

-- no tilde for blank lines; hatched area instead of dashes for diff filler lines
vim.opt.fillchars = { eob = " ", diff = "╱" }

-- diagnostics: inline rendering is done by tiny-inline-diagnostic.nvim
-- (wraps long TS errors nicely); float on <leader>cd for the full detail
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  severity_sort = true, -- errors before warnings, everywhere
  float = { border = "rounded", source = true, max_width = 100 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- keep cursor always in the middle of the screen except top and bottom
-- vim.opt.scrolloff = 999

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
