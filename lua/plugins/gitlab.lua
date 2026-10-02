-- Review GitLab merge requests without leaving Neovim: MR diff in diffview, discussion threads as a
-- side tree, inline comments/suggestions, approve / rebase / merge, pipeline status.
--
-- Runs a Go sidecar the plugin compiles at :Lazy build time -> the Go toolchain must be installed.
-- Auth comes from $GITLAB_TOKEN (needs the `api` scope, not just `read_api`); no token on disk.
return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    -- our own spec lives in diffview.lua; do NOT let upstream pull the dlyongemallo fork instead,
    -- both claim the `diffview` module and lazy would load two copies of it
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  build = function()
    require("gitlab.server").build(true)
  end,
  -- Entry points only. setup() registers the rest of the gl* family once the plugin is loaded,
  -- so a review always starts from one of these four.
  keys = {
    {
      "glc",
      function()
        require("gitlab").choose_merge_request()
      end,
      desc = "GitLab: [c]hoose merge request",
    },
    {
      "glS",
      function()
        require("gitlab").review()
      end,
      desc = "GitLab: [S]tart review of current branch",
    },
    {
      "gls",
      function()
        require("gitlab").summary()
      end,
      desc = "GitLab: MR [s]ummary",
    },
    -- Same four actions under <leader>g, where the rest of the git maps live: the bare gl*
    -- prefix is easy to forget when every other mapping in this config starts with <Space>.
    {
      "<leader>gmr",
      function()
        require("gitlab").review()
      end,
      desc = "MR: [r]eview current branch",
    },
    {
      "<leader>gmc",
      function()
        require("gitlab").choose_merge_request()
      end,
      desc = "MR: [c]hoose merge request",
    },
    {
      "<leader>gms",
      function()
        require("gitlab").summary()
      end,
      desc = "MR: [s]ummary",
    },
    {
      "<leader>gmn",
      function()
        require("gitlab").create_mr()
      end,
      desc = "MR: [n]ew merge request",
    },
    {
      "glC",
      function()
        require("gitlab").create_mr()
      end,
      desc = "GitLab: [C]reate merge request",
    },
  },
  opts = {
    -- Without a URL the plugin talks to gitlab.com, which is wrong for every repo here. Derive the
    -- instance from the origin remote instead of hardcoding it, so self-hosted (gitlab.herole.de,
    -- reached over ssh:// on a non-standard port) and gitlab.com both work from the same config.
    auth_provider = function()
      local token = vim.env.GITLAB_TOKEN
      if not token then
        return nil, nil, "GITLAB_TOKEN is not set"
      end
      local url = vim.env.GITLAB_URL
      if not url then
        local remote = vim.fn.systemlist({ "git", "remote", "get-url", "origin" })[1]
        if vim.v.shell_error == 0 and remote then
          -- host of ssh://git@host:4222/g/r.git, git@host:g/r.git and https://user@host/g/r.git alike
          local rest = (remote:gsub("^%a[%w+.%-]*://", ""))
          rest = (rest:gsub("^[^/@]*@", ""))
          local host = rest:match("^([^:/]+)")
          if host then
            url = "https://" .. host
          end
        end
      end
      return token, url, nil
    end,
    reviewer_settings = {
      -- false = diff the MR revisions exactly as GitLab stored them, so comment line anchors always
      -- match the web UI. Set true to put the working tree on the right-hand side (editable while
      -- reviewing) at the cost of drift whenever local HEAD differs from the MR head.
      diffview = { imply_local = false },
    },
    -- Threads read better beside the code than under it.
    discussion_tree = {
      position = "right",
      size = "35%",
    },
    discussion_signs = {
      -- Threads are published as INFO diagnostics, which options.lua's
      -- `virtual_lines = { current_line = true }` then renders under the cursor line.
      enabled = true,
      virtual_text = false,
      use_diagnostic_signs = true,
    },
  },
}
