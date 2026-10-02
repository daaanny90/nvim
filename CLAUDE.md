# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository

Personal Neovim configuration (kickstart.nvim-derived, pure Lua, targets Neovim 11+). Managed as part of the user's dotfiles (yadm), not its own git repo at `~`.

## Formatting

`stylua.toml`: 2-space indent, 120 column width. Run StyLua via the configured `conform.nvim` (formats on save) or `stylua .` from the repo root.

## Load order (`init.lua`)

Modules `require`d in this fixed order before plugins load — keep it intact when adding setup logic:

1. `globals` — sets `<Space>` as leader/local-leader, nerd-font flag, and registers `lua_ls` via the **native** `vim.lsp.config` / `vim.lsp.enable` API (Nvim 11). `lua_ls` is the only LSP server enabled globally; all others are per-project (see below).
2. `options` — editor settings. Notable: `virtual_lines = { current_line = true }` for diagnostics, spell EN+DE, global statusline.
3. `keybindings` — core maps including `kj` → Esc, `<C-hjkl>` window nav, `<leader>pc` `:PreCommitCheck`, `<leader>wr` `:Weekly`.
4. `autocmd` — yank highlight, lazy.nvim bootstrap + rtp prepend, **background Homebrew + Mason outdated-package checks** whose counts are surfaced in the statusline.
5. `commands` — registers `:PreCommitCheck`, `:Weekly`, `:RestartLsp` (see below).
6. `lazy.setup` — `dev.path = lua/plugins/my-plugins/`, auto-imports all `lua/plugins/*.lua` via `{ import = "plugins" }`. Update checker runs hourly.

`lua/colorscheme-choice.lua` is loaded as a plugin spec (from `lua/plugins/colorscheme.lua`), **not** required from `init.lua`. It also re-applies transparent sign-column/gutter highlights on every `ColorScheme` event.

## LSP architecture (post-migration)

The old `nvim-lspconfig`-based setup has been removed (`lua/plugins/lsp-config.lua` deleted). Current model:

- **`lua/plugins/lsp-native.lua`** — thin spec on `cmp-nvim-lsp` whose `config` registers a single `LspAttach` autocmd that holds **all** LSP keybindings (`gd`, `gr`, `<leader>ca`, `K`, inlay hint toggle, etc.). Server definitions do not live here.
- **`lua/projects/*.lua`** — the actual `vim.lsp.config[name] = {...}` definitions and `vim.lsp.enable(name)` calls live in **per-project files** (see next section), so language servers attach only when the relevant project is open. Exception: `lua_ls` in `globals.lua`.
- **`lua/plugins/mason.lua`** — installs tool binaries only (eslint-lsp, json-lsp, yaml-language-server, emmet, css-lsp). It does **not** call `vim.lsp.enable`.
- **`lua/plugins/typescript-tools.lua`** — `pmizio/typescript-tools.nvim` replaces native `ts_ls` (wraps tsserver with `@vue/typescript-plugin`). Project files contain a commented-out `ts_ls` config you can re-enable to revert.
- **`lua/plugins/schemastore.lua`** — JSON/YAML schema catalog, consumed inside project LSP configs for `jsonls` / `yamlls`.
- Formatting is handled by `conform.nvim`, **not** by LSP. ESLint runs as `vscode-eslint-language-server` and lints only.

When adding a new language server: define it inside the appropriate `lua/projects/*.lua`, not in a central file.

## Per-project config (`lua/projects/`)

`lua/plugins/nvim-projectconfig.lua` configures `nvim-projectconfig`, which watches `DirChanged` and sources the matching file from `lua/projects/` based on a directory-name substring. Currently mapped: `kundenportal`, `herole`, `kila`, `menu-smart-organizer`, `busmeister`, `depaudit`, `ui-library`, `zanicchi`, plus an `Iot-Plan` file. Each project file owns its LSP server stack (e.g. Vue+ts_ls+eslint only enables in Vue projects).

When the user mentions a project name, look in `lua/projects/<name>.lua` for its config before assuming anything is global.

## Custom commands

- **`:PreCommitCheck`** (`lua/commands.lua`, key `<leader>pc`) — opens a floating window, runs pnpm `test`, `type-check`, `lint` sequentially. Has special handling for the **herole Docker monorepo** (multi-package workspace).
- **`:Weekly`** (key `<leader>wr`) — generates a German weekly-report buffer template.
- **`:RestartLsp`** — restarts attached LSP clients (useful when iterating on per-project configs).
- **`:ThemePicker`** (`lua/theme-picker.lua`, key `<leader>uc`) — floating picker whose entries are **parsed out of `lua/colorscheme-choice.lua`**, so list and persistence target cannot drift. Live preview on cursor move, `<CR>` persists + syncs the paired tmux theme, `a` applies nvim only, `q`/`<Esc>` restores. Writes are line-surgical (comment/uncomment a single line); the highlight-override block at the bottom of the choice file is never touched. Pairs resolve by exact name, with a small override table for the asymmetric ones (`iterm2-dark-background` → `iterm2-muted`, variant collapses); themes with no tmux counterpart leave `theme-choice.tmux` alone.

## Colorscheme switching

Mechanism documented in the user's global CLAUDE.md. `lua/colorscheme-choice.lua` contains a list of `vim.cmd.colorscheme(...)` lines, all commented except the active one. Pair the change with the matching tmux theme in `~/.config/tmux/theme-choice.tmux`, then `tmux source-file ~/.tmux.conf`.

The custom `claude-desktop` scheme comes from plugin `daaanny90/claude-desktop.nvim` (registered in `lua/plugins/colorscheme.lua`).

## Custom plugins (`lua/plugins/my-plugins/`)

Resolved via lazy's `dev.path`:

- **`vim-colors-xcode`** — git submodule, original VimScript Xcode colorscheme variants + iTerm2 color files.
- **`xcode-lua/`** — hand-written pure-Lua port (`xcode-dark` / `xcode-light`) against the Xcode 15+ palette, with Treesitter / LSP-semantic-token / 30+ plugin integrations. Registered with `dev = true`.

## Plugin notes worth knowing

- **`claudecode.nvim`** — `provider = "none"` is intentional: Claude Code runs in a tmux pane and connects via `/ide`; do not change this to spawn a terminal split. Keys: `<leader>as` (send selection), `<leader>ab` (add buffer), `<leader>aa` / `<leader>ad` (accept/deny diff).
- **`gitlab.nvim`** — GitLab MR review inside Neovim (`lua/plugins/gitlab.lua`). Lazy-loads on four entry actions, each bound twice: the plugin's native `glc` (choose MR), `glS` (review current branch), `gls` (summary), `glC` (create MR), and the leader aliases `<leader>gmc` / `<leader>gmr` / `<leader>gms` / `<leader>gmn` — the bare `gl*` prefix is easy to miss in a config where everything else starts with `<Space>`. `setup()` then registers the rest of the `gl*` family — note `g?` (plugin help) shadows the built-in rot13 operator.
  - **Worktrees:** the user keeps many worktrees per repo. `choose_merge_request()` checks the MR branch out locally, which git refuses when another worktree already holds that branch (not yet observed here, but it is the documented git behaviour). The reliable flow is therefore `cd` into the ticket's worktree, then `review()` — the branch is already checked out and nothing needs switching.
  - **Auth:** no `.gitlab.nvim` file and no token on disk. `auth_provider` in the spec reads `$GITLAB_TOKEN` (needs the `api` scope, not `read_api`) and derives the instance URL from the `origin` remote host, because the plugin otherwise defaults to `gitlab.com`. Self-hosted `gitlab.herole.de` is reached over `ssh://…:4222/`, which both the Lua host matcher and the Go server's own regex parse correctly.
  - **Diffview:** depends on our existing `sindrets/diffview.nvim` spec, deliberately *not* the `dlyongemallo/diffview.nvim` fork upstream recommends — both provide the `diffview` module. Switching to the fork (drop-in, adds "mark file as viewed") means editing `lua/plugins/diffview.lua`, not adding a second spec.
  - **Go:** `build` compiles a Go sidecar into `~/.local/share/nvim/gitlab.nvim/bin/server`, so the Go toolchain must stay installed (`brew install go`). The binary is version-checked against the Lua code and silently rebuilt on mismatch.
  - Discussion threads are published as INFO diagnostics, so `options.lua`'s `virtual_lines = { current_line = true }` renders the comment text under the cursor line.
- **`grug-far.nvim`** — project search-and-replace at `<leader>sr` (n/v) and `<leader>sW`.
- **`snipe.nvim`** — `<leader>bb` letter-hint buffer picker.
- **`package-info.nvim`** — inline npm versions in `package.json` (`<leader>ns/nu/nd/ni/nc`).
- **`nvim-treesitter-textobjects`** — `af/if`, `ac/ic`, `aa/ia`; `]f` / `[f` jumps.
- **`vim-matchup`** — enhanced `%`, off-screen match popup. Treesitter engine disabled for `php` (bundled query references the removed `php_end_tag` node).
- **`nvim-treesitter`** — pinned to the frozen `master` branch, which is **not** compatible with Nvim 0.12: the `all = false` compatibility option was removed from three query APIs, so callers still passing it get `TSNode[]` capture lists where they expect a single node. `lua/plugins/treesitter.lua` carries two shims that restore the unwrapping — remove both only when migrating to the `main` branch:
  - `patch_query_registration()` (in `init`, must run **before** the plugin registers its handlers) — fixes `add_predicate` / `add_directive`. Without it every markdown injection throws `attempt to call method 'range' (a nil value)`: fenced code blocks lose per-language highlighting and vim-matchup errors on each matchparen tick.
  - `patch_iter_matches()` (in `config`) — fixes `Query:iter_matches`, whose lists reach `TSRange.from_nodes` via nvim-treesitter's own `iter_prepared_matches`. Without it all of `nvim-treesitter-textobjects` throws `attempt to call method 'start' (a nil value)` (`af`/`if`, `ac`/`ic`, `]f`/`[f`).

## Removed plugins

Per recent history: `avante`, `backseat`, `eslint-lsp` (as a standalone plugin), `nvim-lint`, `nvim-lspconfig`-based `lsp-config`, `spectre`, `vim-test` (replaced by neotest + neotest-vitest), `3rd/image.nvim` (never configured, iTerm2 lacks kitty graphics), `oil.nvim` (unused; `-` is back to the default motion and netrw handles directory edits), `multiple-cursors.nvim` (unused; its README-default `<Leader>a`/`<Leader>d`/`<Leader>l` maps sat on complete prefixes and silently shadowed `<leader>a*` (claudecode, codecompanion), the whole `<leader>d*` DAP group, and `<leader>l*`), `bufferline.nvim` (unused tab bar; buffer switching goes through `<leader>be` (neo-tree) and `<leader>bb` (snipe), and `<S-h>`/`<S-l>`/`[b`/`]b` were reinstated as native `:bprevious`/`:bnext` in `lua/keybindings.lua`). Do not reintroduce them without explicit user request — most were replaced (e.g. spectre → grug-far, lspconfig → native `vim.lsp`, nvim-lint → ESLint LSP). Note: `dap-ui` was previously listed here by mistake — it is live and configured in `lua/plugins/dap.lua` alongside the js/vue DAP setup.
