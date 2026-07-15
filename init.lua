-- [[ Global Settings (Must happen before plugins are loaded)]]
require("globals")

-- [[ Setting options ]]
require("options")

-- [[ Keymaps ]]
require("keybindings")

-- [[ Basic Autocommands ]]
require("autocmd")

-- [[ Custom Commands ]]
require("commands")

-- [[ Configure and install plugins ]]
require("lazy").setup({
  dev = {
    path = "~/.config/nvim/lua/plugins/my-plugins/",
  },
  spec = {
    { import = "plugins" },
  },
  checker = {
    enabled = true,
    notify = true,
    frequency = 3600, -- check every hour
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
