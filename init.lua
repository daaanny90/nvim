-- [[ Global Settings (Must happen before plugins are loaded)]]
require 'globals'

-- [[ Setting options ]]
require 'options'

-- [[ Keymaps ]]
require 'keybindings'

-- [[ Basic Autocommands ]]
require 'autocmd'

-- [[ Configure and install plugins ]]
require('lazy').setup {
  { import = 'plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
