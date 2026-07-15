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

## Colorscheme switching

Mechanism documented in the user's global CLAUDE.md. `lua/colorscheme-choice.lua` contains a list of `vim.cmd.colorscheme(...)` lines, all commented except the active one. Pair the change with the matching tmux theme in `~/.config/tmux/theme-choice.tmux`, then `tmux source-file ~/.tmux.conf`.

The custom `claude-desktop` scheme comes from plugin `daaanny90/claude-desktop.nvim` (registered in `lua/plugins/colorscheme.lua`).

## Custom plugins (`lua/plugins/my-plugins/`)

Resolved via lazy's `dev.path`:

- **`vim-colors-xcode`** — git submodule, original VimScript Xcode colorscheme variants + iTerm2 color files.
- **`xcode-lua/`** — hand-written pure-Lua port (`xcode-dark` / `xcode-light`) against the Xcode 15+ palette, with Treesitter / LSP-semantic-token / 30+ plugin integrations. Registered with `dev = true`.

## Plugin notes worth knowing

- **`claudecode.nvim`** — `provider = "none"` is intentional: Claude Code runs in a tmux pane and connects via `/ide`; do not change this to spawn a terminal split. Keys: `<leader>as` (send selection), `<leader>ab` (add buffer), `<leader>aa` / `<leader>ad` (accept/deny diff).
- **`grug-far.nvim`** — project search-and-replace at `<leader>sr` (n/v) and `<leader>sW`.
- **`snipe.nvim`** — `<leader>bb` letter-hint buffer picker.
- **`package-info.nvim`** — inline npm versions in `package.json` (`<leader>ns/nu/nd/ni/nc`).
- **`nvim-treesitter-textobjects`** — `af/if`, `ac/ic`, `aa/ia`; `]f` / `[f` jumps.
- **`vim-matchup`** — enhanced `%`, off-screen match popup.

## Removed plugins

Per recent history: `avante`, `backseat`, `dap-ui`, `eslint-lsp` (as a standalone plugin), `nvim-lint`, `nvim-lspconfig`-based `lsp-config`, `spectre`. Do not reintroduce them without explicit user request — most were replaced (e.g. spectre → grug-far, lspconfig → native `vim.lsp`, nvim-lint → ESLint LSP).
