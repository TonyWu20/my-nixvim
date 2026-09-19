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

## Deliberate simplifications (nixvim defaults)

Where the old config had heavy bespoke Lua, nixvim ships curated defaults.
The rewrite uses those instead of translating every line:

- **alpha**: nixvim default splash. The old ASCII art and two buttons are dropped.
- **lualine**: nixvim default statusline. The custom components are dropped.
- **bufferline, indent-blankline, gitsigns**: nixvim defaults. The hand-rolled
  catppuccin overrides and IBL scope node lists are dropped.
- **lazy.nvim UI keymaps** (`<leader>ph` to `<leader>px`): dropped.
  nixvim does not use lazy.nvim, so there is no `:Lazy` UI.

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

## Remaining work

- Update the consumer `~/nixos-config/nvim/default.nix`. Drop `programs.neovim`
  and the `myNvim` block. That lives in a separate repo.
