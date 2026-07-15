-- Native Neovim 11 LSP Configuration
-- This sets up LSP keybindings and autocommands using Neovim 11's built-in LSP

return {
  {
    -- This is just a dummy plugin to ensure LSP setup runs after cmp
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      -- LspAttach autocmd - runs when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Telescope applies defaults.file_ignore_patterns (node_modules, .git)
          -- to LSP results too, silently dropping definitions that live in
          -- node_modules (e.g. library components' .d.ts) and reporting
          -- "No LSP Definitions found". Disable the filter for LSP pickers only.
          local function lsp_picker(name)
            return function()
              require("telescope.builtin")[name]({ file_ignore_patterns = {} })
            end
          end

          -- Keybindings
          map("gd", lsp_picker("lsp_definitions"), "[G]oto [D]efinition")
          map("gr", lsp_picker("lsp_references"), "[G]oto [R]eferences")
          map("gI", lsp_picker("lsp_implementations"), "[G]oto [I]mplementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
          map("<leader>cl", "<cmd>LspInfo<cr>", "[L]sp info")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Inlay hints toggle
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })
    end,
  },
}

