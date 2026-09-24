# Rewriting this repo on top of `nixvim`

## Why

The repo hand-shipped `init.lua`, a `lua/` tree, and `lazy.nvim`.
A home-manager module copied those into `~/.config/nvim` and wired `programs.neovim`.
That does not use [nixvim](https://github.com/nix-community/nixvim).
This rewrites the repo to configure Neovim through the nixvim Nix module system.

## What changes

- `flake.nix` adds a `nixvim` input.
- It exposes a home-manager module. That module imports
  `nixvim.homeModules.nixvim` and enables `programs.nixvim`.
- A new `nixvim-config/` module holds the whole config. It sets
  `options`, `globals`, `colorschemes.catppuccin`, `plugins`, `lsp.servers`,
  `keymaps`, and runtime `extraPackages`.
- Removed: `init.lua`, `lua/`, `nvim/default.nix`, `lazy-lock.json`.
  Nixvim-generated config replaces all of it.

## Mapping (old to nixvim)

- **Mason is gone.** Nixvim ships language servers as nixpkgs packages.
  `lsp_deps` becomes `lsp.servers.<name>.enable = true`.
  Nixvim adds the matching binaries to `PATH`.
- **Formatters.** `shfmt` and `stylua` come from nixpkgs now. They are wired
  through `plugins.none-ls` plus `extraPackages`.
- **Colorscheme.** `catppuccin-macchiato` becomes `colorschemes.catppuccin`
  with `flavour = "macchiato"`. The nixvim module auto-wires the integrations.
- **LaTeX symbols.** The vendored `latex_symbols_data.lua` is replaced by the
  `plugins.blink-cmp-latex` module.
- **Telescope extensions.** `frecency` and `live-grep-args` are native nixvim
  modules. `telescope-fzf-native` stays dropped, per `plugin-selection.md`.
- **Non-bundled plugins** have no nixvim module. They are added via
  `extraPlugins`. Four come from `pkgs.vimPlugins` (`smartyank-nvim`,
  `mini-surround`, `focus-nvim`, `lean-nvim`). Two have no nixpkgs package,
  so they are built from pinned source (`search.nvim`, `nvim-treehopper`).

## Simplifications and preserved behavior

Where the old config had bespoke Lua that maps cleanly onto nixvim defaults,
the rewrite uses the defaults instead of translating every line:

- **lualine**: nixvim default statusline. The custom components are dropped.
- **indent-blankline**: nixvim default. The hand-rolled scope node lists are
  dropped.
- **lazy.nvim UI keymaps** (`<leader>ph` to `<leader>px`): dropped. nixvim
  uses lz-n, so there is no `:Lazy` UI.

Bespoke behavior that is preserved and ported to Nix:

- **alpha**: the old ASCII art and the two search buttons, plus the old
  layout spacing and the dynamic footer (see "Fixed: alpha dashboard
  spacing" below). The buttons now call `require('search').open` on the
  `file` and `pattern` collections.
- **gitsigns**: the buffer-scoped hunk keymaps live in `settings.on_attach`.
- **bufferline**: the `always_show_bufferline`, close/right-click `BufDel`,
  and LSP diagnostics options are kept.
- **catppuccin**: the custom highlight overrides are kept via
  `settings.custom_highlights`.

Everything else is ported to Nix. That covers the editing keymaps, the suda,
tree, bufdel, and bufferline maps, plus the telescope maps. It also covers all
`vim` options and the LSP attach keymaps.

## Build status

`nix flake check .` and `nix flake check --all-systems .` both pass.
The `nixvim` derivation builds for x86_64-linux and aarch64-linux.

Fixes applied to reach a green build:

- **Unfree packages.** `default.nix` sets `nixpkgs.config.allowUnfree` to
  `true`. A few plugins (e.g. `faster.nvim`, no license field in nixpkgs) are
  tagged unfree. We do not set `nixpkgs.pkgs`, so `nixpkgs.config` is allowed.
- **Raw-Lua helper.** The `nlua` helper is `lib.nixvim.mkRaw`, not
  `nestedLiteralLua`. Plugin `settings` typed `strLua` or `strLuaFn` and keymap
  `action`s accept a plain string or a `mkRaw` value. A `nestedLiteralLua`
  attrset is rejected. `mkRaw` emits the code as unquoted Lua.
- **vim-matchup globals.** The plugin module exposes them as typed settings.
  Set them on `plugins.vim-matchup.settings.*`. Do not set freeform
  `globals.matchup_*`. That collides with the typed plugin options.
- **Clipboard.** Use the nixvim `clipboard` module. That means
  `clipboard.register = "unnamedplus"`. The raw `options.clipboard.register`
  form is not valid.
- **Lazy-load events.** `VeryLazy` is a lazy.nvim event. lz-n rejects it at
  startup because it is passed to `nvim_create_autocmd`. Replace it with valid
  Neovim autocmd events. `blink-cmp` now uses `BufReadPost`.

## Restored: two plugins not in nixpkgs

`search.nvim` and `nvim-treehopper` have no `pkgs.vimPlugins.*` attribute in
the nixpkgs revision that nixvim pins. This Nix refuses to lock them as
source-only flake inputs, so they are built inline in `extraPlugins`.

Each entry is a `pkgs.vimUtils.buildVimPlugin` that pins `owner`, `repo`,
`rev`, and `sha256`. The `sha256` is the Nix `nix32` base32 of the NAR
output hash, not the tarball digest.

Both entries set `doCheck = false`. The `neovimRequireCheck` hook `require`s
each Lua module in isolation. But `search` loads `telescope` at startup.
Disabling the check keeps the build green without shipping a telescope
dependency into the FOD.

The ff/fp search maps, the `on_press` triggers, the `m` tree-hopper map, and
the `require('search')` block in `extra-lua.nix` now resolve. Both plugins
are installed.

## Fixed: the line-number column was missing

`nixvim-config/options.nix` set its table under the key `options`. Nixvim's
top-level option for `vim.opt.*` is `opts`. `options` is not a nixvim option.
So the module system silently dropped the table.

Every `vim.opt` then fell back to Neovim defaults. That hid the line-number
column. `number` was off and `signcolumn` was auto.

Fix: rename the key to `opts`. The values now apply globally. This matches the
old `nvim_set_option_value(name, value, {})` calls.

Verified in the running binary: `number=true`, `relativenumber=true`,
`signcolumn=yes`.

The option set was reconciled against the old `lua/core/options.lua`:

- Restored 28 missing plain editor options. Examples: `autowrite`,
  `cursorcolumn`, `virtualedit`, `shada`, `switchbuf`, `textwidth`, `wrap`,
  `synmaxcol`, `foldenable`.
- Aligned values to the old config: `completeopt`, `formatoptions`
  (`"1jcroql"`), `history = 2000`, and `wildignore`.
- Skipped env-specific options. They referenced `global.cache_dir` and conda
  paths. These are `backupdir`, `backupskip`, `directory`, `undodir`,
  `spellfile`. `clipboard` is covered by nixvim's `clipboard.register`.
- `undolevels = 10000` is new. `breakat` drops one stray backslash.

## Fixed: lazydev completion crashed every non-lua insert

`plugins.blink-cmp` listed `lazydev` in `settings.sources.default`. blink
builds every default provider on `InsertEnter`. It loads each provider's Lua
module.

But `lazydev.integrations.blink` only lands on `package.path` after
`lazydev.nvim` loads. That plugin lazy-loads on `ft = "lua"`. So opening any
non-lua file and entering insert mode crashed with
`module 'lazydev.integrations.blink' not found`.

Fix: drop `lazydev` from `sources.default`. Register it per-filetype instead:

```nix
settings.sources.per_filetype = nlua ''
  { lua = { "lazydev", inherit_defaults = true } }
'';
```

For a lua buffer the provider works. `lazydev` loads first via the `ft`
lazy-load. For every other buffer it is not in the enabled set. The module
is never loaded, so there is no crash.

## Fixed: LspAttach keymaps rewired to the Neovim 0.12 API

Decision: rewire, do not drop. The three broken leader maps now use live 0.12
API:

- `<leader>li` (info): `show_client_info` is gone. A hand-rolled summary
  (id, name, `c.config.cmd`, `root_dir`) is shown via `vim.notify`. Reads the
  client's `config.cmd`, because a 0.12 client carries no runtime `cmd` field.
- `<leader>lr` (restart): `vim.lsp.buf.restart` is gone. Stops the active
  client with the `Client:stop()` method, then `vim.lsp.start` on a deep copy
  of the registered config with `root_dir` pinned. `LspAttach` fires again, so
  the autocmd re-registers the keymaps.
- `<leader>ca` (code action for selection): `select_code_action` is gone.
  Rewired to `lspBufAction = "code_action"`, which is the live 0.12 function
  (floating UI, applied to the visual range in visual mode).

Also swapped the two deprecated calls for their live forms:
`vim.lsp.get_active_clients()` -> `vim.lsp.get_clients({ bufnr })` and
`vim.lsp.stop_client(id)` -> `client:stop()`.

Verified in 0.12.5: every `lspBufAction` target (`definition`,
`declaration`, `references`, `implementation`, `hover`, `document_symbol`,
`signature_help`, `code_action`) is non-nil, so the `LspAttach` loop completes
with no `rhs:` error. A live `pylsp` client attaches, the restart map
stop-starts it and it reattaches, and the info map prints the command.

## Fixed: ts-autotag legacy-setup hint on entering insert

Entering insert mode printed:

> nvim-ts-autotag: Using the legacy setup opts! Please migrate to the new
> setup options layout as this will eventually have its support removed in
> 1.0.0!

The plugin (unstable-2026-04-15) moved its toggles from top-level `setup()`
keys to a nested `opts` table. Top-level `enable_rename`/`enable_close`/
`enable_close_on_slash` now trigger a deprecation notice (the plugin's
`config/plugin.lua` detects a truthy top-level key and `vim.notify`s it).
Because the plugin lazy-loads on `InsertEnter`, the notice only appeared on
the first insert.

Our `plugins.ts-autotag.settings.*` is passed straight into `setup()`, so the
top-level keys hit the legacy path. Migrate to the new layout, which nests
the toggles under an `opts` table. Since all three values equal the plugin's
built-in defaults (`enable_close = true`, `enable_rename = true`,
`enable_close_on_slash = false`), the `settings` block is dropped entirely and
the plugin's defaults apply:

```nix
plugins.ts-autotag = {
  enable = true;
  lazyLoad.settings.event = "InsertEnter";
  # No settings: the plugin defaults already match what we want. If overrides
  # are ever needed, use `settings.opts.*` (never top-level legacy keys).
};
```

Verified: the generated init no longer passes any top-level legacy keys, and a
headless insert into an HTML buffer no longer emits the notice.

## Added: lspsaga and vim-sleuth (plugin-selection update)

`plugin-selection.md` flipped `nvimdev/lspsaga.nvim` and `tpope/vim-sleuth`
to kept. Both are installed through first-class nixvim modules, not
`extraPlugins`.

- `plugins.lspsaga` — lazy on `LspAttach`, same trigger as the old
  `completion.lua` spec. The functional settings are ported from
  `lua/modules/configs/completion/lspsaga.lua`. The icon-glyph fields
  (`ui.kind`, `ui.imp_sign`, `ui.expand`, `ui.collapse`, `ui.code_action`,
  `ui.actionfix`, `symbol_in_winbar.separator`) are dropped on purpose.
  `nvim-web-devicons` is already installed and supplies the glyphs.
  `hover.open_cmd` keeps the old `core.settings.external_browser` default,
  `silent ! chrome-cli open`. `implement` stays enabled while
  `symbol_in_winbar` stays off, matching the old config. The build warns
  about that combination. The warning is accepted.
- `plugins.sleuth` — lazy on `BufNewFile`, `BufReadPost`, `BufFilePost`,
  with no settings. The module defaults already match the old `editor.lua`
  spec.

### nvim-tree keymap migration

The old "filetree: Toggle" binding was `<C-n>` driving
`require("edgy").toggle("left")`. Edgy was dropped in the rewrite, so the
binding never migrated. `keymaps.nix` now maps `<C-n>` to
`:NvimTreeToggle<CR>`. The `<leader>nf/nr/nt` maps stay as they were.
`plugins.nvim-tree` also gained `autoClose = true`. That ports the
`NvimTreeAutoClose` autocmd from the old `core/event.lua`. The tree quits
when it is the last window in the tab.

### `lsp.keymaps` rerouted through lspsaga

The LSP-attach keymaps are now the old `M.lsp` from
`lua/keymap/completion.lua`, routed through lspsaga:

- `gd` previews the definition, `gD` jumps to it, `gr`/`gR` rename in
  file/project range, `K` shows the doc hover.
- `ga` runs `:Lspsaga code_action` in both `n` and `v` modes. The nixvim
  keymap option takes one mode per entry, so the old `nv` combo becomes
  two entries.
- `gh`/`gm`/`gto` open the telescope `lsp_references`, `lsp_implementations`
  and `lsp_document_symbols` pickers (the old helper `picker()` calls).
- `g[`/`g]` jump between diagnostics, `gci`/`gco` show incoming/outgoing
  calls, `<leader>lx` shows line diagnostics, `<leader>lh` toggles inlay
  hints.
- `<leader>li`/`<leader>lr` keep their Neovim 0.12 rewrites. The old
  `<leader>ca` is folded into `ga`. The old `<leader>lv` virtual-lines
  toggle is dropped with tiny-inline-diagnostic.

Verified headless: with a lua_ls client attached, every mapping above
resolves to a `:Lspsaga` or `:Telescope` action. `:Lspsaga` is undefined
before the first LSP attach, so the lazy-load trigger still works.

## Fixed: alpha dashboard spacing and dynamic footer

The old dashboard had padding between sections and a live footer. The
first port dropped both: the layout went straight from the ASCII art to
the buttons, then to a static footer line.

- Spacing is restored with alpha `padding` items: 2 blank lines after
  the art (old `head_butt_padding`) and 1 before the footer (old
  `foot_butt_padding`). The old dynamic top gap is ported as a
  function-valued padding item. It recomputes
  `ceil((winheight - occupied) * 0.25)` at draw time, where occupied is
  19 art lines + 2*2 buttons + 2 head padding, matching the old
  `header_padding` formula. The button count (2) is hardcoded, as the
  old code did.
- The footer is now a function-valued text section. It renders the
  nvim version, the plugin count, and the "in Mms" startuptime. The
  old Nerd Font glyphs (U+F004, U+F028, U+F096) are kept as Lua byte
  escapes.
- The count comes from `nvim_get_runtime_file` over the pack start +
  opt directories, since lz-n has no stats API.
- The timing was first dropped in this port, then restored. See
  "Restored: alpha footer startuptime" below.

Verified headless: the generated init renders the dashboard with the
expected blank lines and a footer reading
`" Have Fun with neovim v0.12.5 65 plugins in <N>ms"`.

## Restored: alpha footer startuptime ("in Mms")

The old lazy.nvim footer read `lazy.stats().startuptime`. lz-n has no
stats API. The first port therefore dropped the timing fragment. The
timer is restored without a stats API. It uses a captured monotonic
baseline.

- Baseline capture: an `extraConfigLuaPre` block in `extra-lua.nix`
  stores `(vim.uv or vim.loop).hrtime()` in `vim.g.nixvim_start_ns`.
  The block lands in the generated init ahead of the extra-config
  plugin setup and the dashboard draw. The baseline is therefore the
  early-init point, close to process start.
- Footer render: the footer function in `plugins.nix` computes the
  delta to `hrtime()` in ms. It rounds to 0.01ms and freezes the
  value in `vim.g.nixvim_alpha_start_ms` on first render. Later
  dashboard redraws reuse the frozen value. That matches the old fixed
  `startuptime`. If the baseline is missing, it falls back to 0 ms.
- Why not `reltime()`: no-arg `reltime()` is boot-relative. It
  returns system uptime, not process-start time, so it cannot measure
  startup. Two monotonic `hrtime()` readings do the job: one captured
  early, one at first render.

## Added: smart-splits (restored the old split-focus keys)

The old `ui.lua` split bindings (`<C-h/j/k/l>`, `<A-h/j/k/l>`,
`<leader>Wh/Wj/Wk/Wl`) were lost when `smart-splits.nvim` was left out of
the first port. It is now enabled.

- `plugins.smart-splits` — enabled. Lazy on `CursorHold`/`CursorHoldI` plus
  12 `cmd` stubs for the `:Smart*` commands. That makes the focus/resize/swap
  keys work on first press instead of waiting for the first idle.
- The 12 keymaps live in `keymaps.nix` under the "smart-splits" section.
- Settings port the old `splits.lua` (`default_amount = 3`, ignored
  `NvimTree` buffers). They equal the plugin defaults and are stated
  explicitly.
- `plugin-selection.md` marks it kept. `keybinds-migration.md` records it as
  MIGRATED with the full reasoning.

## Keybind audit

`keybinds-migration.md` is the complete migrated / dropped / adapted list for
every old keybind. It classifies each one and names the plugin it depends on.
Nothing was dropped on style grounds. Drops happen only when the plugin is not
installed here.

Final pass also restored two non-plugin maps that lived outside any plugin:

- `t <Esc><Esc>` → `<C-\><C-n>` (leave terminal). The old `tool.lua` grouped
  it under toggleterm, but the action is the builtin escape, so it is kept in
  `keymaps.nix`.
- The `q` closes non-listed buffers autocmd from old `core/event.lua`. It is
  ported verbatim to `extra-lua.nix` (`qf`/`help`/`man`/`nofile`/`terminal`
  and friends get `buflisted=false` plus a buffer-local `q` → `:close`).

`gc`/`gcc` are Neovim 0.12 builtin comment operators. comment.nvim (lazy on
`CursorHold`) adds `gb`/`gbc` and the extra `gco`/`gcO`/`gcA`.

## Fixed: statusline lost the active LSP server indicator

The nixvim lualine defaults (mode/branch/filename/encoding/progress/location)
have no LSP client-name component, so the statusline no longer showed which
server is active. The old nvimdots statusline
(`lua/modules/configs/ui/lualine.lua`) rendered a custom `components.lsp`
that listed the attached server names next to the diagnostics count.

The indicator is ported into `settings.sections.lualine_c` as a raw-Lua
component: `filename` keeps the default section-c entry, `diagnostics`
restores the old error/warn counts, and the raw component renders
`LSP[<name, ...>]` for the servers attached to the current buffer (quiet
when none). Verified headless: on a Lua buffer with an attached client it
renders `LSP[lua_ls]`; on a plain text buffer it stays empty.

Nix gotcha found while landing this: Nix has no single-quoted strings.
Raw-Lua values in Nix lists must be wrapped in double-quoted strings
(`nlua "..."`), with any Lua string literals written as single-quoted.

## Remaining work

- Update the consumer `~/nixos-config/nvim/default.nix`. Drop `programs.neovim`
  and the `myNvim` block. That lives in a separate repo.
