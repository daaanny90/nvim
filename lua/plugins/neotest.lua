-- modern test runner (replaces vim-test): per-test signs in the gutter, inline
-- failure output, summary tree, and DAP debugging of single tests via js-debug
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Test nearest",
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Test current file",
    },
    {
      "<leader>ta",
      function()
        -- in monorepos (herole) vitest lives in the package, not the repo
        -- root: run the nearest package.json dir above the current file
        local file_dir = vim.fn.expand("%:p:h")
        local pkg = vim.fs.find("package.json", { upward = true, path = file_dir })[1]
        local dir = pkg and vim.fs.dirname(pkg) or vim.uv.cwd()
        require("neotest").run.run(dir)
      end,
      desc = "Test all (nearest package)",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Test last",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Test debug nearest (DAP)",
    },
    {
      "<leader>tp",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Test panel (summary tree)",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Test output (nearest)",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Test output panel",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          -- keep test discovery out of heavy dirs in the monorepos
          filter_dir = function(name)
            return name ~= "node_modules" and name ~= "dist" and name ~= "coverage"
          end,
        }),
      },
    })
  end,
}
