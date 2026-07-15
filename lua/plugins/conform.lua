return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = false })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = function()
    -- Run a formatter only when the project itself defines that tool's config, so conform never imposes prettier/eslint defaults on a project that never adopted them.
    local function project_has(ctx, names)
      return vim.fs.find(names, { path = ctx.dirname, upward = true, type = "file", limit = 1 })[1] ~= nil
    end

    local prettier_configs = {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.json5",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.toml",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.mjs",
      ".prettierrc.ts",
      "prettier.config.js",
      "prettier.config.cjs",
      "prettier.config.mjs",
      "prettier.config.ts",
    }
    local eslint_configs = {
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yml",
      ".eslintrc.yaml",
    }

    return {
      notify_on_error = true,
      notify_no_formatters = true,
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { "stylua" },
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        vue = { "prettier", "eslint_d" },
        scss = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        astro = { "prettier" },
      },
      format_on_save = function(bufnr)
        return {
          timeout_ms = 3000,
          lsp_fallback = false,
        }
      end,
      formatters = {
        -- Skip prettier unless the project has a prettier config file (package.json "prettier" key is not detected).
        prettier = {
          condition = function(_, ctx)
            return project_has(ctx, prettier_configs)
          end,
        },
        -- Skip eslint auto-fix unless the project defines eslint rules.
        eslint_d = {
          condition = function(_, ctx)
            return project_has(ctx, eslint_configs)
          end,
          -- pnpm keeps peer plugins of legacy shareable configs (FlatCompat
          -- extends "standard" in kundenportal) in node_modules/.pnpm/node_modules,
          -- unreachable from the daemon's plain require walk: expose it via
          -- NODE_PATH. Read at daemon spawn — if formatting still fails after
          -- the daemon was first started in another project, `eslint_d restart`.
          env = function(_, ctx)
            for dir in vim.fs.parents(ctx.filename) do
              local hoist = dir .. "/node_modules/.pnpm/node_modules"
              if vim.uv.fs_stat(hoist) then
                return { NODE_PATH = hoist }
              end
            end
          end,
        },
      },
    }
  end,
}
