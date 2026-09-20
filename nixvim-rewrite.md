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

- **alpha**: the old ASCII art and the two search buttons. The buttons now
  call `require('search').open` on the `file` and `pattern` collections.
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

## Remaining work

- Update the consumer `~/nixos-config/nvim/default.nix`. Drop `programs.neovim`
  and the `myNvim` block. That lives in a separate repo.
