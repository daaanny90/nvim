-- {
--   'nvim-pack/nvim-spectre',
--   build = false,
--   cmd = 'Spectre',
--   opts = { open_cmd = 'noswapfile vnew' },
--     -- stylua: ignore
--     keys = {
--       { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
--     },
-- }
-- {
--   'nvim-pack/nvim-spectre',
--   build = false,
--   cmd = 'Spectre',
--   opts = { open_cmd = 'noswapfile vnew' },
--     -- stylua: ignore
--     keys = {
--       { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
--     },
-- }
return -- search/replace in multiple files
-- {
--   'nvim-pack/nvim-spectre',
--   build = false,
--   cmd = 'Spectre',
--   opts = { open_cmd = 'noswapfile vnew' },
--     -- stylua: ignore
--     keys = {
--       { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
--     },
-- }
{
  'MagicDuck/grug-far.nvim',
  opts = { headerMaxWidth = 80 },
  cmd = 'GrugFar',
  keys = {
    {
      '<leader>sr',
      function()
        local grug = require 'grug-far'
        local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
        grug.grug_far {
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        }
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
    },
  },
}
