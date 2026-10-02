-- Nvim 0.12 removed the `all = false` compatibility option from three treesitter query APIs.
-- Callers that still pass it now receive `TSNode[]` capture lists where they expect a single
-- TSNode, and nvim-treesitter is pinned to the frozen `master` branch, which passes it everywhere.
-- These two shims restore the old unwrapping so the plugin keeps working. Drop them when
-- migrating to the `main` branch. Every affected capture is unquantified in practice, so the
-- list always holds exactly one node and which element we pick does not matter.
local function unwrap_captures(match)
  local single = {}
  for id, nodes in pairs(match) do
    single[id] = type(nodes) == "table" and nodes[#nodes] or nodes
  end
  return single
end

---`add_predicate` / `add_directive`: handlers indexing `match[id]` as a node throw
---"attempt to call method 'range' (a nil value)". This breaks every markdown injection
---(`set-lang-from-info-string!`), so fenced code blocks lose per-language highlighting and
---vim-matchup errors on each matchparen tick. Must run before nvim-treesitter registers.
local function patch_query_registration()
  local query = vim.treesitter.query
  for _, name in ipairs({ "add_predicate", "add_directive" }) do
    local register = query[name]
    query[name] = function(pred_name, handler, opts)
      if type(opts) == "table" and opts.all == false then
        local single_node_handler = handler
        handler = function(match, ...)
          return single_node_handler(unwrap_captures(match), ...)
        end
      end
      return register(pred_name, handler, opts)
    end
  end
end

---`Query:iter_matches`: nvim-treesitter's own match pipeline (`iter_prepared_matches`) feeds the
---lists straight into `TSRange.from_nodes`, which throws "attempt to call method 'start'
---(a nil value)" — that breaks all of nvim-treesitter-textobjects (`af`/`if`, `]f`/`[f`).
---The class is not exported, so reach it through the metatable of a parsed query.
local function patch_iter_matches()
  local ok, sample = pcall(vim.treesitter.query.parse, "lua", "(comment) @c")
  if not ok then
    return
  end

  local Query = getmetatable(sample)
  if not Query or type(Query.iter_matches) ~= "function" then
    return
  end

  local iter_matches = Query.iter_matches
  Query.iter_matches = function(self, node, source, start, stop, opts)
    local iter = iter_matches(self, node, source, start, stop, opts)
    if type(opts) ~= "table" or opts.all ~= false then
      return iter
    end
    return function()
      local pattern, match, metadata = iter()
      if pattern == nil then
        return nil
      end
      return pattern, unwrap_captures(match), metadata
    end
  end
end

return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- Pin to the legacy `master` branch: the default `main` branch is an incompatible rewrite
  -- (new API, requires Nvim 0.12). This stops `:Lazy update` from silently jumping to it and
  -- breaking `require('nvim-treesitter.configs')` below.
  branch = "master",
  build = ":TSUpdate",
  init = function()
    if vim.fn.has("nvim-0.12") == 1 then
      patch_query_registration()
    end
  end,
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    if vim.fn.has("nvim-0.12") == 1 then
      patch_iter_matches()
    end

    -- Prefer git instead of curl in order to improve connectivity in some environments
    require("nvim-treesitter.install").prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
