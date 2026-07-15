# Neovim Config — Agent Context

Hand-off document for an AI agent jumping into `~/.config/nvim`. Read this first; then dive into specific files.

---

## TL;DR (30-second brief)

- **Heavily customized, LazyVim-derived** setup. `lazyvim.json` exists but **extras = `[]`** — none of LazyVim's `extras` modules are active. Hand-rolled everything.
- **No `lua/config/` directory.** Top-level lua modules sit directly in `lua/`.
- **LSP**: Neovim 0.11 native (`vim.lsp.config[...]` + `vim.lsp.enable(...)`). Server definitions are scattered across `lua/globals.lua` and per-project files in `lua/projects/`.
- **Per-project config** via `windwp/nvim-projectconfig` (mapping table in `lua/plugins/nvim-projectconfig.lua`). Active project file is `require`d based on cwd directory name.
- **Format-on-save** = `conform.nvim` (NOT the LSP). `lsp_fallback = false` on save. Debug log: `~/.local/state/nvim/conform.log` (`log_level = DEBUG`).
- **TS LSP** = `pmizio/typescript-tools.nvim` (recently replaced `ts_ls`; `ts_ls` config is kept commented in every project file as a revert path).
- **Plugin manager**: `lazy.nvim` bootstrapped from inside `lua/autocmd.lua` (unusual — not from `init.lua`).
- **Dotfiles**: managed by **yadm** (`~` is not a git repo). Theme switching is coordinated between tmux and nvim via twin "one uncommented line" selectors.
- **Leader** = `<Space>`, `localleader` = `<Space>` (set in `lua/globals.lua`).
- **User language**: Italian (replies in Italian); code/commits/PRs stay English.

---

## Filesystem layout

```
~/.config/nvim/
├── init.lua                    # entry; requires top-level modules then lazy.setup
├── lazyvim.json                # extras=[] — LazyVim extras are NOT used
├── lua/
│   ├── globals.lua             # leader, lua_ls config + enable
│   ├── options.lua             # editor options (2-space indent, signcolumn, etc.)
│   ├── keybindings.lua         # global non-LSP keymaps
│   ├── autocmd.lua             # autocmds + lazy.nvim bootstrap + Mason/brew checks
│   ├── commands.lua            # PreCommitCheck, Weekly, RestartLsp
│   ├── colorscheme-choice.lua  # "one uncommented line" theme selector
│   ├── plugins/                # plugin specs (one file per plugin)
│   │   ├── lsp-native.lua      # global LSP keymaps + LspAttach handler (no servers)
│   │   ├── mason.lua           # Mason + ensure_installed
│   │   ├── conform.lua         # format-on-save (gated by project config)
│   │   ├── nvim-projectconfig.lua  # project→file mapping table
│   │   ├── typescript-tools.lua    # active TS LSP
│   │   ├── …(~50 plugin files)…
│   │   ├── my-plugins/         # local custom plugins (dev.path target)
│   │   │   ├── vim-colors-xcode/
│   │   │   └── xcode-lua/
│   │   └── dap-adapters/
│   │       └── vscode-php-debug/   # embedded PHP debug adapter (node)
│   └── projects/               # per-project configs loaded by nvim-projectconfig
│       ├── herole.lua          # MAIN shared LSP config for Herole work
│       ├── kundenportal.lua    # require("projects.herole")
│       ├── heroleui.lua        # require("projects.herole") (mapped to dir "ui-library")
│       ├── depaudit.lua        # own LSP + BufWritePre EslintFixAll autocmd
│       ├── Iot-Plan.lua        # own LSP set
│       ├── busmeister.lua      # require("projects.herole")
│       ├── menu-smart-organizer.lua  # own LSP set
│       ├── zanicchi.lua        # own LSP set
│       └── (kila.lua referenced but DOES NOT EXIST — dead reference)
└── AGENT_CONTEXT.md            # this file
```

---

## Load order (what runs when)

`init.lua` does:

```lua
require("globals")        -- leader, lua_ls
require("options")        -- editor options
require("keybindings")    -- global keymaps
require("autocmd")        -- autocmds + bootstraps lazy.nvim
require("commands")       -- user commands
require("lazy").setup({ { import = "plugins" } }, { dev = { path = "lua/plugins/my-plugins" }, ... })
```

**Quirk**: `lazy.nvim` bootstrap (clone-if-missing) lives inside `lua/autocmd.lua`, not `init.lua`. The `require("lazy").setup` call works because `autocmd.lua` runs first and prepends the lazypath to rtp.

`lazy.setup` uses `dev = { path = "lua/plugins/my-plugins" }` so local plugins (xcode themes) resolve there. Updates auto-checked hourly with notifications.

---

## Plugin layer

- **~50 plugin specs** in `lua/plugins/*.lua`, one per plugin. Cherry-picked from LazyVim and elsewhere — no LazyVim extras.
- **`my-plugins/`** holds custom local plugins:
  - `vim-colors-xcode/` — embedded vimscript Xcode colorscheme.
  - `xcode-lua/` — custom Lua-native Xcode colorscheme (`xcode-dark`/`xcode-light`).
- **`dap-adapters/vscode-php-debug/`** — full embedded Node debug adapter (treat as vendored).

---

## LSP architecture (important, non-standard)

There is **no central LSP config file**. Server setup is split:

1. **`lua/plugins/lsp-native.lua`** — **global keymaps only**, no server definitions. One `LspAttach` autocmd registers `gd`, `gr`, `gI`, `K`, `<leader>D`, `<leader>ds`, `<leader>ws`, `<leader>cr`, `<leader>cl`, `<leader>ca`, `gD`, `<leader>th` (inlay toggle) for every attached buffer.
2. **`lua/globals.lua`** — only `lua_ls` defined + enabled globally (so it works in the config itself).
3. **`lua/projects/*.lua`** — every other LSP server defined and enabled here, scoped per-project by `nvim-projectconfig`.

**TS LSP** is the active `pmizio/typescript-tools.nvim` (configured globally in `lua/plugins/typescript-tools.lua` — filetypes ts/js/jsx/tsx/vue, includes `@vue/typescript-plugin`). In every project file, `ts_ls` is **kept defined but commented out**:

```lua
-- vim.lsp.enable("ts_ls")  -- DISABLED: replaced by typescript-tools.nvim (uncomment to revert)
```

So reverting is a single-line toggle per project.

`herole.lua` (the most fleshed-out project file) defines: `vue_ls` (with capability stripping so it doesn't shadow ts_ls), `jsonls` (schemastore), `yamlls` (schemastore), `ts_ls` (disabled), `eslint` (with `format = false` and `EslintFixAll` user command in on_attach), `emmet_language_server`, `cssls`. Plus DAP php (FIXME: not working) and `vim.g["test#javascript#runner"] = "vitest"`.

---

## Per-project config — mapping table

Loaded by `windwp/nvim-projectconfig` based on cwd dir name. From `lua/plugins/nvim-projectconfig.lua`:

| Directory name        | Loads                      | Effective LSP source        |
|-----------------------|----------------------------|------------------------------|
| `kundenportal`        | `kundenportal.lua`         | → `require("projects.herole")` |
| `herole` (herole_website) | `herole.lua`           | self (full set)              |
| `ui-library`          | `heroleui.lua`             | → `require("projects.herole")` |
| `busmeister`          | `busmeister.lua`           | → `require("projects.herole")` |
| `menu-smart-organizer`| `menu-smart-organizer.lua` | self                         |
| `depaudit`            | `depaudit.lua`             | self + `BufWritePre EslintFixAll` autocmd |
| `kila`                | `kila.lua` (**MISSING**)   | dead reference               |
| `zanicchi`            | `zanicchi.lua`             | self                         |
| (`Iot-Plan.lua` exists in `projects/` but is **not registered** in nvim-projectconfig) |

**Key fact**: `kundenportal`, `herole_website`, `ui-library`, `busmeister` all funnel into `herole.lua`. Touch `herole.lua` and you change all four.

The user's main work projects live under `~/Projects/Herole/` (e.g. `~/Projects/Herole/herole_website/apps/vue/`). `herole_website` uses **ESLint flat config (`eslint.config.cjs`) and has NO prettier config** — it does not use prettier at all.

---

## Formatting (recently fixed — read carefully)

**Driver**: `lua/plugins/conform.lua` — `stevearc/conform.nvim`. NOT the LSP. `format_on_save` uses `lsp_fallback = false`, and the `<leader>f` manual keymap was also set to `lsp_fallback = false` so the typescript-tools default tsserver formatter NEVER imposes VS Code defaults.

**Formatters by filetype**:

```lua
typescript      = { "eslint_d" }
javascript      = { "eslint_d" }
typescriptreact = { "prettier", "eslint_d" }
javascriptreact = { "prettier", "eslint_d" }
vue             = { "prettier", "eslint_d" }
scss/css/html/json/astro = { "prettier" }
lua             = { "stylua" }
```

**Gating** (key design): each of `prettier` and `eslint_d` has a `condition` that calls `vim.fs.find(..., { upward = true })` against the file's dirname. The formatter runs **only when the project has the corresponding config file** in an ancestor directory:

- `prettier` runs iff a `.prettierrc*` or `prettier.config.*` is found (note: `package.json` `"prettier"` key is NOT detected — add a config file if used).
- `eslint_d` runs iff an `eslint.config.*` or `.eslintrc*` is found.

This means projects that never adopted prettier/eslint will NOT be reformatted. Was a recent fix to stop nvim imposing rules ("regole mai definite e mai usate" the user complained about) on projects without those configs.

**Debug log** (the empirical source of truth for "why did saving reformat X?"):

```
~/.local/state/nvim/conform.log
```

Tail this for exact formatter + CLI args + CWD per save. Use it before guessing.

**eslint_d quirk**: it's a daemon; it caches config across projects. After config changes or weird "rules from another project leaking in," run `eslint_d restart` (mason bin: `~/.local/share/nvim/mason/bin/eslint_d restart`).

**ESLint LSP** (separate from eslint_d) is enabled per-project for **diagnostics only** (`settings.format = false`); the `EslintFixAll` user command is created in `on_attach` but only runs on demand (except in `depaudit.lua` which has a `BufWritePre` autocmd firing `silent! EslintFixAll`).

---

## User commands (`lua/commands.lua`)

| Command          | Shortcut       | What it does |
|------------------|----------------|--------------|
| `PreCommitCheck` | `<leader>pc`   | Floating terminal runs `pnpm test:unit`, `test:e2e`, `type-check`, `lint` sequentially (skips missing scripts). In herole monorepo, e2e runs via `docker compose --profile e2e run paul`. |
| `Weekly`         | `<leader>wr`   | Opens a buffer with a German weekly report template auto-filled with next Friday's date + ISO week. |
| `RestartLsp`     | `<leader>lr`   | Stops all LSP clients on current buffer, saves, re-opens after 1s. |

---

## Notable keymaps (`lua/keybindings.lua`)

Flat file, direct `vim.keymap.set`. Highlights:

- `i:kj` → `<ESC>`
- `v:J` / `v:K` → move selection down/up
- `<leader>bd` → wipeout buffer (keep window)
- `<leader>cD` → `neogen.generate()` (docstring)
- `<leader>gr` → `!npm repo <cword>` (open npm repo of word under cursor in browser)
- `<leader>f` → `require("conform").format({ async = true, lsp_fallback = false })`

LSP keymaps (`gd`, `gr`, etc.) live in `lua/plugins/lsp-native.lua` `LspAttach`.

---

## Options (`lua/options.lua`)

- Leader: `<Space>` (set in `globals.lua`).
- Indent: 2 spaces (`tabstop`/`shiftwidth`/`expandtab`).
- `signcolumn = "yes"`, `laststatus = 3` (global statusline), `timeoutlen = 600` (300 caused accidental `<leader>p` triggers).
- Spell: both `en_us` and `de_de` (user is German-speaking).
- Diagnostics: `virtual_text = false`, `virtual_lines = { current_line = true }` (inline only for current line), emoji signs (❌ ⚠️ ℹ️ 💡).
- Tilde chars hidden on empty lines.

---

## Themes (coordinated with tmux)

Both selectors follow a **"one uncommented line"** pattern — all other lines commented; switching themes = comment one, uncomment another.

- nvim: `lua/colorscheme-choice.lua` — current: `vim.cmd.colorscheme("iterm2-dark-background")`.
- tmux: `~/.config/tmux/theme-choice.tmux` — current: `source-file ~/.config/tmux/themes/iterm2-muted.tmux`.

`colorscheme-choice.lua` also defines `apply_custom_highlights()` (called immediately + on `ColorScheme` autocmd) that strips backgrounds from `LineNr`, `SignColumn`, `GitSigns*`, `DiagnosticSign*`, and sets a custom `LualineLsp` highlight (`#FFFFFF` on `#2563EB`).

**Recommended pairs** (from user's global CLAUDE.md):

| tmux                | nvim                       |
|---------------------|----------------------------|
| `iterm2-muted`      | `iterm2-dark-background`   |
| `claude-desktop`    | `claude-desktop`           |
| `kanagawa-dragon`   | `kanagawa-dragon`          |
| `solarized-osaka`   | `solarized-osaka`          |
| `everforest`        | `everforest`               |

After changing tmux theme: `tmux source-file ~/.tmux.conf`.

The `claude-desktop` nvim colorscheme comes from the plugin `daaanny90/claude-desktop.nvim` (see `lua/plugins/colorscheme.lua`).

---

## Mason / installed tools (`lua/plugins/mason.lua`)

`ensure_installed`: `eslint-lsp`, `json-lsp`, `yaml-language-server`, `emmet-language-server`, `css-lsp`.

NOT in the list (assumed/managed elsewhere): `typescript-language-server`, `lua-language-server`. `eslint_d`, `prettier`, `stylua` also installed via Mason but not in this list.

Mason has `check_outdated_packages_on_open = true`; `lua/autocmd.lua` also computes `vim.g.mason_outdated_count` for the statusline.

---

## Background autocmds (in `lua/autocmd.lua`)

- Yank highlight (`TextYankPost` → `vim.hl.on_yank`).
- `lazy.nvim` bootstrap (clone if missing, prepend to rtp).
- Async `brew outdated neovim` check → sets `vim.g.nvim_update_available` for statusline.
- Mason outdated count → `vim.g.mason_outdated_count` (debounced).
- Italic comments for xcode colorscheme (FIXME: doesn't work in tmux).

---

## Debug (DAP)

- PHP via `vscode-php-debug` (embedded in `lua/plugins/dap-adapters/vscode-php-debug/`).
- `dap.configurations.php`: "Listen for Xdebug" on port 9003, with `pathMappings` for docker (`/var/www/html → ${workspaceFolder}/website`).
- **FIXME**: marked "not working at all" in `herole.lua` — server starts but breakpoints don't fire. Backend runs in docker; pathMapping suspected not working.

## Test runner

`vim-test` configured for **vitest** as the JS runner: `vim.g["test#javascript#runner"] = "vitest"` (set in `herole.lua`).

---

## Known quirks / footguns

1. `lua/projects/kila.lua` is referenced in `nvim-projectconfig.lua` but **does not exist on disk** → dead reference; trying to open a `kila/` dir will warn.
2. `lua/projects/Iot-Plan.lua` **exists but is not registered** in `nvim-projectconfig.lua`. Orphan.
3. `kundenportal.lua`, `heroleui.lua`, `busmeister.lua` are just `require("projects.herole")` → changing `herole.lua` changes all four projects.
4. `ts_ls` is defined but disabled in every project file — uncomment the `vim.lsp.enable("ts_ls")` line to revert (and probably disable `typescript-tools.lua`).
5. `lazyvim.json` exists but is **inert** (`extras = []`). Don't trust it as a signal that LazyVim's machinery is in use.
6. `eslint_d` daemon caches config across projects — restart it after rules behave weirdly.
7. conform `<leader>f` keymap has `lsp_fallback = false` to suppress tsserver default formatting; if a file has no conform formatter, `<leader>f` does nothing by design.
8. depaudit's `BufWritePre EslintFixAll` autocmd is scoped to the depaudit project file (loaded only when cwd matches), but it patterns `*.tsx/*.ts/*.jsx/*.js/*.vue` — if it somehow loads in another project (e.g. nested cwd), it will fire across all those filetypes.
9. The user runs Italian / German (spell), code English.

---

## Common task recipes

**Change theme:**
1. `lua/colorscheme-choice.lua` — comment current `vim.cmd.colorscheme(...)`, uncomment target.
2. `~/.config/tmux/theme-choice.tmux` — comment current `source-file ...`, uncomment target.
3. `tmux source-file ~/.tmux.conf`.

**Add a new project:**
1. Add entry in `lua/plugins/nvim-projectconfig.lua` (`path = "dirname"`, `config = "~/.config/nvim/lua/projects/X.lua"`).
2. Create `lua/projects/X.lua` (either define LSPs directly or `require("projects.herole")`).

**Diagnose unexpected on-save formatting:**
1. `tail -f ~/.local/state/nvim/conform.log` then save the file.
2. Log shows exact formatter + CWD + CLI args.
3. If `eslint_d` looks confused: `~/.local/share/nvim/mason/bin/eslint_d restart`.
4. If formatter shouldn't be running: check `condition` in `lua/plugins/conform.lua` and project config-file presence.

**Add/change a formatter:**
- Edit `formatters_by_ft` in `lua/plugins/conform.lua`.
- Add a `condition` in `formatters = { ... }` if it should be gated on project config.

**Revert TS LSP to `ts_ls`:**
1. Comment out / disable `lua/plugins/typescript-tools.lua`.
2. In the relevant project file, uncomment `vim.lsp.enable("ts_ls")`.

---

## User environment (from global CLAUDE.md)

- macOS, dotfiles via **yadm** (`~` is not a git repo; configs under `~/.config/`).
- Replies expected in **Italian**; code/comments/commits stay English.
- Node via nvm (e.g. `~/.nvm/versions/node/v20.20.0/...`).
- Subagent delegation rule: when this agent is asked to explore code, it should delegate via the `Agent` tool to `Explore` or `general-purpose` with explicit `model` param (default `sonnet`, `haiku` for trivial lookups). Main thread reserved for architectural decisions and synthesis.

---

## Recent migrations / context

- Recently migrated to Neovim 0.11 native LSP API (`vim.lsp.config` + `vim.lsp.enable`). Commits like `wip still figuring out nvim 11 lsp config (now works)`, `fix lsp for nvim 11`.
- Switched TS LSP from `ts_ls` → `typescript-tools.nvim`. Old config kept commented.
- Vue setup migrated to v3 model: `vue_ls` (replaces deprecated `volar`) handles template/style; ts_ls + `@vue/typescript-plugin` handle script (now `typescript-tools.nvim` carries the plugin via `tsserver_plugins`). No `hybridMode`.
- conform.nvim recently gated to respect per-project formatter configs (the "regole mai definite" fix) — see [Formatting](#formatting-recently-fixed--read-carefully).

---

## Entry points to read in order if you're a fresh agent

1. This file (you're here).
2. `init.lua` — see the load chain.
3. `lua/plugins/nvim-projectconfig.lua` — to know which project loads what.
4. `lua/projects/herole.lua` — covers most of the user's work.
5. `lua/plugins/conform.lua` — formatting rules + the `condition` gating logic.
6. `lua/plugins/lsp-native.lua` — global LSP keymaps.
7. Specific plugin file you're working on.
