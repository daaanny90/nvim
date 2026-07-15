-- JSON / YAML schema catalog for LSP
-- Wire into jsonls / yamlls via:
--   settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } }
--   settings = { yaml = { schemas = require("schemastore").yaml.schemas() } }
return {
  "b0o/schemastore.nvim",
  lazy = true,
  version = false,
}
