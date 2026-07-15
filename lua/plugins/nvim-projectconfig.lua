return {
  "windwp/nvim-projectconfig",
  lazy = false,
  priority = 1000,
  opts = {
    project_dir = "~/.config/nvim/lua/projects/",
    project_config = {
      -- herole Projects
      {
        path = "kundenportal",
        config = "~/.config/nvim/lua/projects/kundenportal.lua",
      },
      {
        path = "herole",
        config = "~/.config/nvim/lua/projects/herole.lua",
      },
      {
        path = "kila",
        config = "~/.config/nvim/lua/projects/kila.lua",
      },
      {
        path = "menu-smart-organizer",
        config = "~/.config/nvim/lua/projects/menu-smart-organizer.lua",
      },
      {
        path = "busmeister",
        config = "~/.config/nvim/lua/projects/busmeister.lua",
      },
      {
        path = "depaudit",
        config = "~/.config/nvim/lua/projects/depaudit.lua",
      },
      {
        path = "ui-library",
        config = "~/.config/nvim/lua/projects/heroleui.lua",
      },

      -- Personal Projects
      {
        path = "zanicchi",
        config = "~/.config/nvim/lua/projects/zanicchi.lua",
      },
    },

    silent = false,
    autocmd = true,
  },
}
