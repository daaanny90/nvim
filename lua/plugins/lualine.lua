-- fix for solarized osaka coloscheme, it works only if solarized-osaka is installed
-- otherwise is ignored
local solarized_osaka_hsl
local has_solarized_osaka, solarized_osaka_hslutil = pcall(require, "solarized-osaka.hsl")
if has_solarized_osaka then
  solarized_osaka_hsl = solarized_osaka_hslutil.hslToHex
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function current_working_dir()
  local cwd = string.sub(vim.fn.getcwd(), 12)
  return "~" .. cwd
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

local function lsp_client_at(i)
  return function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local idx = 0
    for _, c in ipairs(clients) do
      idx = idx + 1
      if idx == i and type(c) == "table" then
        return (c.name and c.name ~= "") and c.name or ""
      end
    end
    return ""
  end
end

-- Mason: mostra count quando ci sono update (popolato da check in background)
local function mason_updates()
  local n = vim.g.mason_outdated_count or 0
  if n > 0 then
    return "Mason " .. n .. " ↑"
  end
  return ""
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  lazy = true,
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
    -- Garantisce che LualineLsp esista (sfondo blu, testo bianco) per i componenti LSP
    vim.api.nvim_set_hl(0, "LualineLsp", { fg = "#FFFFFF", bg = "#2563EB" })
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        always_divide_middle = false,
        theme = "auto",
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16,
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "ModeChanged",
            "DiagnosticChanged",  -- quando cambiano errori/warning LSP
            "User LspAttach",
            "User LspDetach",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "b:gitsigns_head", icon = { "" } },
          {
            "diff",
            source = diff_source,
            color = function()
              if solarized_osaka_hsl then
                return { bg = solarized_osaka_hsl(192, 100, 5) }
              end
            end,
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            color = function()
              if solarized_osaka_hsl then
                return { bg = solarized_osaka_hsl(192, 100, 5) }
              end
            end,
          },
        },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = "[]", readonly = " " } },
          { "lsp_progress", display_components = { "lsp_client_name" } },
        },
        lualine_x = {
          {
            mason_updates,
            cond = function() return (vim.g.mason_outdated_count or 0) > 0 end,
            color = { fg = "#D4A84B" },
          },
          {
            function()
              local n = require("lazy.status").updates()
              return (type(n) == "string" or (type(n) == "number" and n > 0)) and tostring(n) or ""
            end,
            cond = function() return require("lazy.status").has_updates() end,
            color = { fg = "#D4A84B" },
          },
          {
            function()
              return vim.g.nvim_update_available and "Nvim ↑" or ""
            end,
            cond = function()
              return vim.g.nvim_update_available == true
            end,
            color = { fg = "#D4A84B" },
          },
          {
            "macro-recording",
            fmt = show_macro_recording,
          },
          {
            function()
              local ok, devicons = pcall(require, "nvim-web-devicons")
              if ok and devicons then
                return devicons.get_icon_by_filetype(vim.bo.filetype, { default = true }) or ""
              end
              return ""
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { current_working_dir },
        },
        lualine_z = vim.iter({
          (function()
            local out = {}
            for i = 1, 6 do
              out[i] = {
                lsp_client_at(i),
                cond = function()
                  local clients = vim.lsp.get_clients({ bufnr = 0 })
                  local idx = 0
                  for _ in ipairs(clients) do
                    idx = idx + 1
                    if idx == i then return true end
                  end
                  return false
                end,
                separator = " ",
                padding = { left = 1, right = 1 },
                color = "LualineLsp",
              }
            end
            return out
          end)(),
          { "location" },
        }):flatten():totable(),
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1, symbols = { modified = "[]", readonly = " " } } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "nvim-dap-ui" },
    }
  end,
}
