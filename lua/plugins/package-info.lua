-- Show npm package versions inline in package.json
return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "json",
  opts = {},
  keys = {
    { "<leader>ns", function() require("package-info").show() end, desc = "[N]pm [S]how versions" },
    { "<leader>nu", function() require("package-info").update() end, desc = "[N]pm [U]pdate package" },
    { "<leader>nd", function() require("package-info").delete() end, desc = "[N]pm [D]elete package" },
    { "<leader>ni", function() require("package-info").install() end, desc = "[N]pm [I]nstall package" },
    { "<leader>nc", function() require("package-info").change_version() end, desc = "[N]pm [C]hange version" },
  },
}
