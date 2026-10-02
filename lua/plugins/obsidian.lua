-- Obsidian vault support. Community fork: epwalsh/obsidian.nvim is archived.
local vault = vim.fn.expand("~") .. "/zettelkasten"

-- Vault convention (see the vault's own CLAUDE.md): note file names are
-- `YYYYMMDDHHmm-slug`, lowercase, hyphens, no accents, no spaces.
local ACCENTS = {
  ["à"] = "a",
  ["á"] = "a",
  ["è"] = "e",
  ["é"] = "e",
  ["ì"] = "i",
  ["í"] = "i",
  ["ò"] = "o",
  ["ó"] = "o",
  ["ù"] = "u",
  ["ú"] = "u",
}

local function note_id(title)
  local stamp = os.date("%Y%m%d%H%M")
  if not title or vim.trim(title) == "" then
    return stamp
  end
  local slug = vim.fn.tolower(title):gsub("[\194-\244][\128-\191]*", function(c)
    return ACCENTS[c] or ""
  end)
  slug = slug:gsub("[^%w]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
  return slug == "" and stamp or (stamp .. "-" .. slug)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  -- Load inside the vault only; the keymaps below load it from anywhere else.
  event = { "BufReadPre " .. vault .. "/*.md", "BufNewFile " .. vault .. "/*.md" },
  opts = {
    legacy_commands = false,
    workspaces = { { name = "zettelkasten", path = vault } },
    picker = { name = "telescope.nvim" },
    -- render-markdown.nvim already renders markdown; obsidian's own conceal would double up
    ui = { enable = false },
    -- new notes land in the inbox, `note/` is written by hand
    notes_subdir = "0-inbox",
    new_notes_location = "notes_subdir",
    note_id_func = note_id,
    -- the vault has its own frontmatter schema (tipo/origine/stato/creato) - never rewrite it.
    -- This also makes the plugin skip its bundled default template, which would inject
    -- an `id`/`aliases`/`tags` block into every new note.
    frontmatter = { enabled = false },
    link = { style = "wiki", auto_update = true },
    daily_notes = { enabled = true, folder = "log", date_format = "YYYY-MM-DD", default_tags = {} },
  },
  keys = {
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: open note" },
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: new note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian: search vault" },
    { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Obsidian: tags" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Obsidian: links in note" },
    { "<leader>oi", "<cmd>Obsidian toc<cr>", desc = "Obsidian: table of contents" },
    { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian: today's note" },
    { "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "Obsidian: pick daily note" },
    { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Obsidian: rename note + links" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Obsidian: toggle checkbox" },
    { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian: paste image" },
    { "<leader>oa", "<cmd>Obsidian open<cr>", desc = "Obsidian: open in app" },
    { "<leader>ok", "<cmd>Obsidian link<cr>", mode = "v", desc = "Obsidian: link selection" },
    { "<leader>oe", "<cmd>Obsidian extract_note<cr>", mode = "v", desc = "Obsidian: extract to new note" },
  },
}
