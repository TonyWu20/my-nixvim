# my-nixvim

A declarative Neovim configuration managed with
[nixvim](https://github.com/nix-community/nixvim), delivered as a
home-manager module. The flake also builds the editor standalone, so the
config can be validated without a full home-manager evaluation.

## Repo layout

```
flake.nix              Flake entry point: inputs and outputs
flake.lock             Pinned inputs (nixpkgs, nixvim, home-manager)
nixvim-config/
  default.nix          Module root: imports, colorscheme, globals, runtime packages
  options.nix          vim.opt.* table
  keymaps.nix          Global keymaps
  plugins.nix          Plugin enable-set, settings, LSP servers, formatters
  extra-lua.nix        pcall-guarded setup() for plugins with no nixvim module
nixvim-rewrite.md      Migration record: old init.lua/lazy.nvim -> nixvim
plugin-selection.md    Why each plugin was kept or dropped
fuzzy-finder-comparison.md  Fuzzy finder decision (search.nvim over the rest)
sessions/              Agent scratch notes (gitignored)
result                 Last `nix build` output (gitignored)
```

## How the flake is wired

`flake.nix` pulls three inputs: `nixpkgs`, `nixvim`, and `home-manager`.
`nixpkgs` is **not** followed into `nixvim`. Nixvim builds its nvim
wrapper against its own pinned nixpkgs revision. That pin is what this
config is validated against.

Two output families:

- `homeModules.default` / `homeManagerModules.default`: the home-manager
  entrypoint. It imports `nixvim.homeModules.nixvim`, enables
  `programs.nixvim` with `defaultEditor = true`, and feeds our module
  through `programs.nixvim.imports`.
- `packages.<system>.default`: a standalone nixvim package built with
  `nixvim.lib.evalNixvim`. This is the fast validation path: it checks the
  whole module tree without a home-manager evaluation.

All config lives in `nixvim-config/`. The module root (`default.nix`)
imports the four sibling files. The split is purely organizational.
Anything nixvim declares as an option can be set in any of them.

## Managing plugins

**1. A plugin with a nixvim module (the common case).**

Enable it in `nixvim-config/plugins.nix`:

```nix
plugins.<name>.enable = true;
```

Add lazy-loading with `lazyLoad.settings`, choosing the trigger that fits:

- `event` for Neovim events (`[ "CursorHold" "CursorHoldI" ]` is the
  house style for "load when the editor is idle").
- `cmd` for command-triggered plugins (`[ "Git" "G" ]` for fugitive).
- `ft` for filetype-triggered plugins (`"lua"` for lazydev, `"rust"` for
  rustaceanvim).

Then set options under `plugins.<name>.settings.*`. These are typed. A
wrong shape fails the build. For options that must hold Lua code (the
`strLua`/`strLuaFn` types), use the `nlua` helper, which is
`lib.nixvim.mkRaw`:

```nix
let nlua = lib.nixvim.mkRaw; in
{
  plugins.gitsigns.settings.on_attach = nlua ''
    function(bufnr) ... end
  '';
}
```

`mkRaw` emits the code as unquoted Lua. The alternative,
`nestedLiteralLua`, is an attrset and is rejected by those option types.

**2. A plugin without a nixvim module.**

There is no module to enable. Instead:

- If nixpkgs ships it, add the package to `extraPlugins` in `plugins.nix`:
  `pkgs.vimPlugins.<name>` (see smartyank-nvim, mini-surround,
  focus-nvim, lean-nvim).
- If nixpkgs does not ship it, build it from pinned source in
  `extraPlugins`. Use `pkgs.vimUtils.buildVimPlugin` with
  `pkgs.fetchFromGitHub`. Pin `rev` and `sha256` for reproducibility.
  See search.nvim and nvim-treehopper.

If the plugin needs a `setup()` call or bespoke Lua, add a pcall-guarded
block to `extra-lua.nix` under `extraConfigLuaPost`:

```nix
pcall(function()
  require('someplugin').setup({ ... })
end)
```

The pcall guard means a missing or renamed plugin degrades at runtime
instead of crashing startup.

**3. Language servers.** No Mason. Servers are nixpkgs packages. Nixvim
adds their binaries to PATH automatically.

```nix
lsp.servers.<name>.enable = true;
```

For a server with a non-standard command, extend with
`lsp.servers.<name>.config.cmd` and `filetypes` (see harper_ls and
nushell in `plugins.nix`). LSP-attach keymaps live in `lsp.keymaps`,
registered on `LspAttach` with `lspBufAction` or raw-Lua `action` entries.

**4. Formatters.** Wired through `plugins.none-ls.sources`, each source
auto-adding its nixpkgs binary to PATH, plus `plugins.lsp-format` for
format-on-save.

**5. Removing a plugin.** Drop the `plugins.<name>` block and its
`extra-lua.nix` setup block. If the colorscheme wires an integration for
it, drop that line under `colorschemes.catppuccin.settings.integrations`.

**6. Runtime packages.** Declared in `extraPackages` in `default.nix`.
For example, `ripgrep` backs `grepprg`, the telescope vimgrep args, and
the blink-ripgrep source.

## Managing the rest of the config

- **Editor options**: `opts.*` in `options.nix`. The user-facing key is
  `opts`, not `options`. `options` is not a declared nixvim option, so the
  module system silently drops it. That silent drop was a real bug in the
  migration.
- **Keymaps**: `keymaps` in `keymaps.nix`. Actions are command strings
  (`":w<CR>"`) or raw-Lua functions via `nlua`.
- **Globals** (`vim.g.*`): the `globals` table in `default.nix`. Use it
  only for globals that no plugin module declares. Plugin-exposed globals
  (e.g. `matchup_*`) are set on `plugins.<name>.settings.*`. Setting them
  freeform collides with the typed options.
- **Bespoke Lua that no module can express**: `extraConfigLuaPost` in
  `extra-lua.nix`. It is a single string, so all blocks concatenate into
  one literal and section headers must use Lua `--` comments, not Nix `#`.
- **Colorscheme**: `colorschemes.catppuccin` in `plugins.nix`, with
  `settings.flavour`, UI `integrations`, and `custom_highlights` (a
  raw-Lua function receiving the palette).
- **Node-based servers** (prettier, ts_ls family): `withNodeJs = true` in
  `default.nix`.
- **Unfree packages**: `nixpkgs.config.allowUnfree = true` in
  `default.nix` (faster.nvim ships no license field in nixpkgs).

## Build and validate

```sh
nix build                 # builds packages.default for the host system
nix run .#default -- bin/nvim   # or use ./result/bin/nvim
```

A green build is the whole config check. It evaluates plugin option
types, keymap shapes, raw-Lua blocks, and the module tree. For
cross-system checks:

```sh
nix flake check .
nix flake check --all-systems .
```

Inside the editor, `:checkhealth` and `:checkhealth nvim-lspconfig`
report what the runtime sees.

## Deploying with home-manager

Import the flake's home module:

```nix
# flake.nix (consumer)
inputs.my-nixvim.url = "github:TonyWu20/my-nixvim";

# home configuration
home.configurations.default =
  { ... ,
    imports = [ inputs.my-nixvim.homeModules.default ];
  };
```

Then `home-manager build` (or the flake equivalent) materializes
`~/.config/nvim` and links the editor. Because `defaultEditor = true`,
the nvim wrapper is exposed as the default editor.

## Updating

- **Inputs** (nixvim, nixpkgs, home-manager): `nix flake update`, then
  `nix build` to validate against the new pins.
- **Pinned-source plugins**: bump the `rev` and `sha256` in their
  `buildVimPlugin` block in `plugins.nix`.
- **Decision docs**: `plugin-selection.md` and
  `fuzzy-finder-comparison.md` record why plugins were kept or dropped.
  Update them when the plugin set changes.
