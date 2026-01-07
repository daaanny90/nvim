return {
  -- All colorscheme plugins are loaded here
  -- To choose which one to use, scroll to the bottom of this file

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        -- palettes = {
        --   carbonfox = {
        --     bg1 = "#0a0a0a",
        --   },
        -- },
      })
    end,
  },

  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        -- Alternatively set style in setup
        -- style = 'light'

        -- Enable transparent background
        transparent = true,

        -- Enable italic comment
        italic_comments = true,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,

        -- Override colors (see ./lua/vscode/colors.lua)
        color_overrides = {
          -- vscLineNumber = '#FFFFFF',
        },

        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })
    end,
  },

  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.sonokai_enable_italic = true
    end,
  },

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").setup({
        cursorline = {
          blend = 0,
        },
      })
    end,
  },

  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          darken = {
            sidebars = {
              enable = false,
            },
          },
        },
      })
    end,
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   require("oxocarbon").setup({
    --     palettes = {
    --       oxocarbon = {
    --         bg1 = "#ffffff",
    --       },
    --     },
    --   })
    -- end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
    end,
  },

  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "bettervim/yugen.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "daaanny90/vim-colors-xcode",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.xcodedarkhc_green_comments = 1
      vim.g.xcodedark_green_comments = 1
    end,
  },

  {
    "wuelnerdotexe/vim-enfocado",
    lazy = false,
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        term_colors = true,
        transparent_background = false,
        styles = {
          conditionals = { "italic" },
          loops = {},
          functions = { "bold" },
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        -- color_overrides = {
        --   mocha = {
        --     base = "#0a0a0a",
        --     mantle = "#191919",
        --     crust = "#191919",
        --   },
        -- },
        integrations = {
          noice = true,
          notify = true,
          cmp = true,
          treesitter = true,
          treesitter_context = true,
        },
      })
    end,
  },

  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("solarized-osaka").setup({
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
        },
        on_highlights = function(highlights, colors)
          highlights.Visual = { bg = colors.base01, reverse = false }
        end,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = true,
      })
    end,
  },

  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = "hard"
    end,
  },

  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      require("solarized").setup(opts)
    end,
  },

  -- ============================================================================
  -- COLORSCHEME SELECTION
  -- To change colorscheme, edit: lua/colorscheme-choice.lua
  -- ============================================================================
  {
    "colorscheme-loader",
    dir = vim.fn.stdpath("config"),
    priority = 1001, -- Load after all colorscheme plugins
    config = function()
      require("colorscheme-choice")
    end,
  },
}
