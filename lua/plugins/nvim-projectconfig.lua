return {
  "windwp/nvim-projectconfig",
  lazy = false,
  priority = 1000,
  opts = {
    project_dir = "~/.config/nvim/lua/projects/",
    project_config = {
      {
        path = "kundenportal",
        config = "~/.config/nvim/lua/projects/kundenportal",
      },
      {
        path = "herole",
        config = "~/.config/nvim/lua/projects/herole",
      },
      {
        path = "kila",
        config = "~/.config/nvim/lua/projects/kila",
      },
      {
        path = "menu-smart-organizer",
        config = "~/.config/nvim/lua/projects/menu-smart-organizer",
      },
      {
        path = "busmeister",
        config = "~/.config/nvim/lua/projects/busmeister",
      },
      {
        path = "depaudit",
        config = "~/.config/nvim/lua/projects/depaudit",
      },
      {
        path = "ui-library",
        config = "~/.config/nvim/lua/projects/heroleui",
      },
    },

    silent = false,
    autocmd = true,
  },
}
