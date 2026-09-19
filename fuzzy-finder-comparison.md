# Fuzzy finder: `tv.nvim` (television) vs `telescope.nvim`

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

- `telescope-frecency` for recent and frequently used files. No TV equivalent.
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
- One small wrapper replaces many extension plugins. More minimal.

## Impact on your current keymaps

Your `lua/keymap/tool.lua` binds these to telescope or search.nvim:

- `<leader>ff` files, `<leader>fp` pattern, `<leader>fg` git, `<leader>fd` dossier, `<leader>fm` misc.
- `<C-p>` keymaps, `<leader>fr` resume, visual `<leader>fs` grep.

Under TV you would rebind these to TV channels such as `files`, `text`, `git-log`, `git-branch`.
You would delete the telescope plugins, the `fzf-lua` backend switch, and the `search.nvim` module.
The visual-grep and keymap-picker bindings have no direct TV channel.
You would rework or drop them.

## Recommendation

The choice hinges on one question.
Do you rely on frecency, undo, zoxide, projects, git-history search, or rich actions?

- If yes, or you value a native extensible theme-integrated picker, keep telescope.
  Trim the extension set to only what you use.
  That removes most of the bloat while keeping the capability you depend on.
- If no, and your goal is a minimal fast hackable search tool, `tv.nvim` fits better.
  It gives one tiny wrapper, no extension sprawl, faster search, and many built-in channels.
  You would give up frecency, undo, zoxide, project, and advanced-git-search pickers.

Given your stated goal is minimal, `tv.nvim` aligns better if you do not need those extensions.
It also pairs well with Nix.
You ship one `television` package instead of seven or more telescope extension plugins.
The main things to give up are the telescope-only pickers and its rich action system.
