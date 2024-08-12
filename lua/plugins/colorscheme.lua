return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- vim.cmd.colorscheme 'tokyonight-night'
  --     -- vim.cmd.colorscheme 'tokyonight-storm'
  --     vim.cmd.colorscheme 'tokyonight-moon'
  --     -- vim.cmd.colorscheme 'tokyonight-day'
  --
  --     vim.cmd.hi 'Comment gui=none'
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
  --     vim.cmd 'colorscheme github_dark_default'
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
  --   'catppuccin/nvim',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('catppuccin').setup {
  --       flavour = 'mocha',
  --       term_colors = true,
  --       transparent_background = false,
  --       -- color_overrides = {
  --       --   mocha = {
  --       --     base = '#000000',
  --       --     mantle = '#000000',
  --       --     crust = '#000000',
  --       --   },
  --       -- },
  --     }
  --     -- load the colorscheme here
  --     vim.cmd [[colorscheme catppuccin]]
  --     vim.o.background = 'dark'
  --   end,
  -- },

  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('solarized-osaka').setup {
        on_highlights = function(highlights, colors)
          highlights.Visual = { bg = colors.base01, reverse = false }
        end,
      }
      vim.cmd.colorscheme 'solarized-osaka'
    end,
  },
}
