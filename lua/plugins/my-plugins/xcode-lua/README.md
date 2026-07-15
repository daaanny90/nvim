# Xcode.nvim

A faithful recreation of Apple's Xcode IDE colorscheme for Neovim, written entirely in Lua.

## Features

- 🎨 **Authentic Xcode colors** - Based on the actual Xcode 15+ color palette
- 🌙 **Dark and Light themes** - Both `xcode-dark` and `xcode-light` variants
- 🌳 **Full Treesitter support** - Semantic highlighting for all languages
- 🔧 **LSP semantic tokens** - Enhanced highlighting from language servers
- 🔌 **Plugin integrations** - Support for 30+ popular Neovim plugins
- ⚡ **Fast** - Pure Lua implementation with lazy loading

## Installation

This colorscheme is already included in your Neovim config as a local plugin.

## Usage

### Basic Usage

In your `colorscheme-choice.lua`, uncomment one of:

```lua
-- Dark theme
vim.cmd.colorscheme("xcode-dark")

-- Light theme  
vim.cmd.colorscheme("xcode-light")

-- Auto-detect based on vim.o.background
vim.cmd.colorscheme("xcode")
```

### Configuration

The colorscheme can be configured by calling `setup()` before loading:

```lua
require("xcode").setup({
  style = "dark",           -- "dark" or "light"
  transparent = false,      -- Enable transparent background
  italic_comments = true,   -- Use italics for comments
  bold_keywords = true,     -- Use bold for keywords
  terminal_colors = true,   -- Set terminal colors
  dim_inactive = false,     -- Dim inactive windows
  lualine_bold = true,      -- Bold section headers in lualine
})

vim.cmd.colorscheme("xcode-dark")
```

### Lualine Integration

Use the built-in lualine theme:

```lua
require("lualine").setup({
  options = {
    theme = require("xcode").lualine_theme(),
  },
})
```

### Accessing Colors

You can access the color palette for custom highlights:

```lua
local palette = require("xcode").palette("dark")
print(palette.pink)  -- "#FC5FA3"
```

## Color Palette

### Dark Theme

| Color       | Hex       | Usage                          |
|-------------|-----------|--------------------------------|
| Background  | `#1F1F24` | Editor background              |
| Foreground  | `#FFFFFF` | Plain text                     |
| Red         | `#FC6A5D` | Strings                        |
| Orange      | `#FD8F3F` | Preprocessor, macros           |
| Yellow      | `#D0BF69` | Numbers, characters            |
| Green       | `#67B7A4` | Variables, properties (teal)   |
| Cyan        | `#5DD8FF` | URLs, system types             |
| Blue        | `#41A1C0` | Other declarations             |
| Purple      | `#A167E6` | Functions, methods             |
| Pink        | `#FC5FA3` | Keywords                       |
| Lavender    | `#D0A8FF` | Project types, interfaces      |
| Comment     | `#6C7986` | Comments                       |

### Light Theme

| Color       | Hex       | Usage                          |
|-------------|-----------|--------------------------------|
| Background  | `#FFFFFF` | Editor background              |
| Foreground  | `#000000` | Plain text                     |
| Red         | `#C41A16` | Strings                        |
| Orange      | `#643820` | Preprocessor (brown)           |
| Yellow      | `#1C00CF` | Numbers (blue in light mode)   |
| Green       | `#326D74` | Variables, properties (teal)   |
| Cyan        | `#0F68A0` | URLs, system types             |
| Purple      | `#3900A0` | Functions, types               |
| Pink        | `#9B2393` | Keywords                       |
| Comment     | `#5D6C79` | Comments                       |

## Supported Plugins

- **Completion**: nvim-cmp, blink.cmp
- **File Explorer**: neo-tree, nvim-tree
- **Fuzzy Finder**: telescope.nvim
- **Git**: gitsigns.nvim
- **Status Line**: lualine.nvim, bufferline.nvim
- **UI**: noice.nvim, nvim-notify, which-key.nvim
- **Navigation**: flash.nvim, leap.nvim
- **Diagnostics**: trouble.nvim, todo-comments.nvim
- **Debugging**: nvim-dap, nvim-dap-ui
- **LSP**: lspsaga.nvim, aerial.nvim, navic
- **Misc**: lazy.nvim, mason.nvim, indent-blankline, mini.nvim, spectre.nvim, illuminate.nvim, nvim-ufo

## Credits

Color palette inspired by Apple's Xcode IDE.

## License

MIT
