# Fuzzy finder: `tv.nvim` (television) vs `telescope.nvim`

**Decision (2026-09-19): keep `telescope.nvim`.**
`tv.nvim` is dropped from the new config.
The minimal telescope set for ff/fp is recorded in `plugin-selection.md`.

Decision aid for picking the fuzzy finder for the new minimal config.
Your current nvimdots setup uses **telescope** heavily.
See `lua/modules/configs/tool/telescope.lua` and `lua/keymap/tool.lua`.
This doc compares swapping it for `tv.nvim`.

## What they actually are

| | telescope.nvim | television / tv.nvim |
|---|---|---|
| Kind | Native Neovim Lua plugin. Native floating window. | Standalone Rust TUI binary plus a thin Lua wrapper. |
| How results render | Native float. Native previewer, sorter, theme integration. | Opens a terminal buffer, runs `tv <channel>`, reads stdout lines back on exit. |
| UI | Native. Integrates with your colorscheme, previewers, layouts, actions. | Its own TUI running inside a terminal window. |
| Ecosystem | Very large. Many extensions and many recipes. | Smaller. 30+ built-in channels, TOML custom channels, ad-hoc mode. |
| Deps to ship | Plugins only (Lua). | The `tv` binary. In Nix, `nixpkgs` ships `television`. |
| Maturity | Mature, active. ~19.8k stars. | `tv.nvim` is young. ~171 stars. The `television` binary is active. ~6.3k stars. |

Key point on architecture.
With **television** the fuzzy UI is a separate process TUI.
It renders in a terminal buffer.
Neovim only hands the selected lines back to a simple handler.
With **telescope** everything runs natively inside Neovim.

## Feature mapping (gain vs loss)

Telescope features in your current config that TV does not provide:

- `telescope-frecency` indexes files opened in Neovim.
  TV has built-in frecency ranking (on by default), but it tracks selections made inside TV.
  The semantics differ. The result set and ranking source are not the same.
- `telescope-zoxide` for zoxide directory jumps. No TV equivalent.
- `telescope-undo` for the undo-tree picker. No TV equivalent.
- `DrKJeff16/project.nvim` project picker. No TV equivalent.
- `advanced-git-search` for commit-content grep and diffview diffs.
  TV has `git-log`, `git-branch`, `git-repos` channels.
  It does not do commit-content search or diffview diffs.
- `telescope-live-grep-args` auto-quoting.
  The TV `text` channel is ripgrep based. You can pass rg flags.
  The auto-quote and `--iglob` prompt keys are telescope specific.
- The `<C-p>` keymap picker and the tabbed collections UI.
  Both are built on telescope and the `search.nvim` module.
- Rich actions: multi-select, custom actions, previewers, sorters, themes.
  TV handlers are coarse.
  They cover open, split, quickfix, clipboard, insert, scratch, shell command.
  There is no multi-select action pipeline. There is no native previewer.

What TV provides that telescope does not:

- Faster native Rust search. Noticeably better on very large repos.
- 30+ built-in channels: `procs`, `gh-prs`, `zsh-history`, `tldr`, `env`, `docker`, `git-repos`.
- Ad-hoc mode: `tv -s "<any shell command>"` turns any command output into a list.
- Custom TOML channels for niche data sources.
- Ships a `catppuccin.toml` theme, so it can pair with your catppuccin-macchiato.
- One small wrapper replaces many extension plugins. More minimal.
- Default channels need `fd`, `rg`, and `bat` in PATH.
  All three are nixpkgs packages.

## Impact on your current keymaps

Your `lua/keymap/tool.lua` binds these to telescope or search.nvim:

- `<leader>ff` files, `<leader>fp` pattern, `<leader>fg` git, `<leader>fd` dossier, `<leader>fm` misc.
- `<C-p>` keymaps, `<leader>fr` resume, visual `<leader>fs` grep.

Under TV you would rebind these to TV channels such as `files`, `text`, `git-log`, `git-branch`.
You would delete the telescope plugins, the `fzf-lua` backend switch, and the `search.nvim` module.
The visual-grep and keymap-picker bindings have no direct TV channel.
You would rework or drop them.

## Your actual usage: `<leader>ff` and `<leader>fp`

Your two habits map cleanly onto TV's two core channels:

- `<leader>ff` → `tv files`
  `nvimdots` opens the "file" collection (tabs: Files, Frecency, Oldfiles, Buffers).
  TV's `files` channel uses `fd` and has built-in frecency ranking, covering
  Files + Frecency in one prompt. Oldfiles and Buffers tabs have no built-in
  channel, but both are easy ad-hoc/custom channels if you want them.
- `<leader>fp` → `tv text`
  `nvimdots` opens the "pattern" collection (tabs: live_grep_args, grep_cword).
  TV's `text` channel is ripgrep-based. Word-under-cursor is a one-liner:
  `require("tv").tv_text(vim.fn.expand("<cword>"))`.

So your two most-used workflows are both first-class TV channels.
The main UX change is losing the tabbed collection view.
Each channel is its own prompt instead of tabbed tabs in one prompt.
TV still has `:Tv` / channel selector to jump between channels.

## Checklist consistency note

Your `plugin-selection.md` keeps only `nvim-telescope/telescope.nvim`.
Every telescope extension and `ayamir/search.nvim` are unchecked.
The ff/fp keymaps run through `require("search").open(...)` in
`lua/modules/configs/tool/search.lua`.
That module needs the frecency, live-grep-args, and zoxide extensions.
So "telescope core only" would break `<leader>ff` and `<leader>fp`.
To keep them on telescope, add back `search.nvim`, `frecency`, and
`live-grep-args` (plus `zoxide` for the dossier tab).

## Recommendation

Your stated usage is `<leader>ff` (files) and `<leader>fp` (pattern grep).
Only.
Both are TV core channels.

- `<leader>ff` → `tv files`. Built-in frecency ranking covers the Frecency tab.
- `<leader>fp` → `tv text`. Word under cursor is a prompt prefill.

You would lose only things you do not use:
- The tabbed collection view (Files/Frecency/Oldfiles/Buffers in one prompt).
  TV opens one prompt per channel.
- Oldfiles and Buffers tabs. No TV channel. Ad-hoc mode or a custom channel
  could cover them later.
- zoxide, undo-tree, project, and git-content-search pickers. You never use
  them.
- The `<C-p>` keymap picker. TV has `:Tv` to list channels.
- Telescope's rich action system (multi-select, custom actions, previewers,
  sorters). Irrelevant for files and grep.

You would gain:
- One small plugin plus one Nix package instead of eight telescope plugins.
- Faster native Rust search.
- Built-in frecency, no frecency plugin needed.
- Nix fits your nixos-config setup: `nixpkgs` ships `television`
  (version 0.15.9, MIT). It provides the `tv` binary. `tv.nvim` is a pure Lua
  plugin that lazy installs from git.

Caveats:
- The UI is a terminal-buffer TUI, not a native float.
  In a GUI client it is a terminal inside Neovim.
- `tv.nvim` is young (created 2025, ~171 stars). The `television` binary is
  mature (~6.3k stars, active).
- TV frecency ranks files selected inside TV, not files opened in Neovim.
  Same goal, different data source.

Bottom line: for a config whose search life is files and grep, `tv.nvim` is
the more minimal choice and your two workflows are drop-in channel calls.
Keep telescope only if you plan to use the extension pickers (zoxide, undo,
projects, git-content search) or the tabbed collection UI.
