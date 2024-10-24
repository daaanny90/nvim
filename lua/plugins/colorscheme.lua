return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     vim.cmd.colorscheme 'tokyonight-night'
  --     -- vim.cmd.colorscheme 'tokyonight-storm'
  --     -- vim.cmd.colorscheme 'tokyonight-moon'
  --     -- vim.cmd.colorscheme 'tokyonight-day'
  --
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },

  -- {
  --   'Mofiqul/dracula.nvim',
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'dracula'
  --   end,
  -- },

  -- {
  --   'bluz71/vim-moonfly-colors',
  --   name = 'moonfly',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'moonfly'
  --   end,
  -- },

  -- {
  --   'Mofiqul/vscode.nvim',
  --   priority = 1000,
  --   config = function()
  --     local c = require('vscode.colors').get_colors()
  --     require('vscode').setup {
  --       -- Alternatively set style in setup
  --       -- style = 'light'
  --
  --       -- Enable transparent background
  --       transparent = true,
  --
  --       -- Enable italic comment
  --       italic_comments = true,
  --
  --       -- Underline `@markup.link.*` variants
  --       underline_links = true,
  --
  --       -- Disable nvim-tree background color
  --       disable_nvimtree_bg = true,
  --
  --       -- Override colors (see ./lua/vscode/colors.lua)
  --       color_overrides = {
  --         -- vscLineNumber = '#FFFFFF',
  --       },
  --
  --       -- Override highlight groups (see ./lua/vscode/theme.lua)
  --       group_overrides = {
  --         -- this supports the same val table as vim.api.nvim_set_hl
  --         -- use colors from this colorscheme by requiring vscode.colors!
  --         Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
  --       },
  --     }
  --   end,
  --   init = function()
  --     vim.cmd.colorscheme 'vscode'
  --   end,
  -- },

  -- {
  --   'sainnhe/sonokai',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Optionally configure and load the colorscheme
  --     -- directly inside the plugin declaration.
  --     vim.g.sonokai_enable_italic = true
  --     vim.cmd.colorscheme 'sonokai'
  --   end,
  -- },

  -- {
  --   'olimorris/onedarkpro.nvim',
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     vim.cmd 'colorscheme onedark'
  --   end,
  -- },

  -- {
  --   'AlexvZyl/nordic.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('nordic').load()
  --   end,
  -- },

  -- {
  --   'shaunsingh/nord.nvim',
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'nord'
  --   end,
  -- },

  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('github-theme').setup {
  --       -- ...
  --     }
  --
  --     vim.cmd 'colorscheme github_dark_dimmed'
  --   end,
  -- },

  -- {
  --   'danwlker/primeppuccin',
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },

  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   init = function()
  --     vim.cmd.colorscheme 'rose-pine'
  --   end,
  -- },

  -- {
  --   'slugbyte/lackluster.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     -- vim.cmd.colorscheme 'lackluster'
  --     vim.cmd.colorscheme 'lackluster-hack' -- my favorite
  --     -- vim.cmd.colorscheme("lackluster-mint")
  --   end,
  -- },

  -- {
  --   'bettervim/yugen.nvim',
  --   config = function()
  --     vim.cmd.colorscheme 'yugen'
  --   end,
  -- },

  {
    'dasp/vim-colors-xcode',
    dev = true,
    config = function()
      vim.g.xcode_green_comments = 1
      vim.cmd.colorscheme 'xcode'
    end,
  },

  -- {
  --   'catppuccin/nvim',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('catppuccin').setup {
  --       flavour = 'mocha',
  --       term_colors = true,
  --       transparent_background = false,
  --       styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
  --         comments = { 'italic' }, -- Change the style of comments
  --         conditionals = { 'italic' },
  --         loops = {},
  --         functions = { 'bold' },
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --         -- miscs = {}, -- Uncomment to turn off hard-coded styles
  --       },
  --       -- color_overrides = {
  --       --   mocha = {
  --       --     base = '#191919',
  --       --     mantle = '#191919',
  --       --     crust = '#191919',
  --       --   },
  --       -- },
  --       integrations = {
  --         noice = true,
  --         notify = true,
  --         cmp = true,
  --         treesitter = true,
  --         treesitter_context = true,
  --       },
  --     }
  --     -- load the colorscheme here
  --     vim.cmd [[colorscheme catppuccin]]
  --     vim.o.background = 'dark'
  --   end,
  -- },

  -- {
  --   'craftzdog/solarized-osaka.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     require('solarized-osaka').setup {
  --       on_highlights = function(highlights, colors)
  --         highlights.Visual = { bg = colors.base01, reverse = false }
  --       end,
  --     }
  --     vim.cmd.colorscheme 'solarized-osaka'
  --   end,
  -- },
}
