# Plugin selection report — from `~/nvimdots/lua/modules/plugins`

Source: `lua/modules/plugins/{completion,editor,lang,tool,ui}.lua` in `~/nvimdots`.
`lua/user/plugins/*.lua` (your overrides) and `lua/user/settings.lua` are carried over as-is.
They are not part of this checklist.

Legend:

- [x] = you already decided to keep (from your "want to keep" list) or you have it disabled in
      `lua/user/settings.lua` `disabled_plugins` today.
- [ ] = your decision.

Your current `disabled_plugins` in `lua/user/settings.lua`:
`ray-x/go.nvim`, `michaelb/sniprun`, `smoka7/hop.nvim`, `andersevenrud/cmp-tmux`.

Settings in your environment that already gate plugins: `use_copilot=false`, `use_chat=false`,
`search_backend=telescope`.
So both AI-prediction branches (minuet, copilot) and the fzf backend are off for you.

## completion.lua — LSP & completion

The core LSP trio you want to keep:

- [x] `neovim/nvim-lspconfig` — LSP client configs (your item 5).
- [x] `mason-org/mason.nvim` — package manager that _installs_ LSP servers (your "installation?" part).
- [x] `mason-org/mason-lspconfig.nvim` — bridges Mason and LSP. nvimdots uses it to auto-install
      servers listed in `settings.lsp_deps` / `null_ls_deps` / `dap_deps` / `treesitter_deps`.
- [ ] `folke/neoconf.nvim` — one-shot LSP config generator (`NeoconfCreate`). Convenience only.
- [] `nvimdev/lspsaga.nvim` — LSP UI: code actions menu, code lens, diagnostic flythrough.
- [ ] `rachartier/tiny-inline-diagnostic.nvim` — inline diagnostic icons in the code.
- [ ] `joechrisellis/lsp-format-modifications.nvim` — LSP format only the lines you changed on save.
- [x] `nvimtools/none-ls.nvim` (+ `jay-babu/mason-null-ls.nvim`) — run external formatters
      (clang_format, prettier, shfmt, stylua, vint…) as LSP.
- [x] `saghen/blink.cmp` — autocompletion engine.
- [ ] `L3MON4D3/LuaSnip` (+ `rafamadriz/friendly-snippets`) — snippet engine + snippet pack.
- [ ] `f3fora/cmp-spell` — spell-based completion source.
- [x] `kdheepak/cmp-latex-symbols` — LaTeX symbols in completion (only matters for LaTeX).
- [x] `mikavilpas/blink-ripgrep.nvim` — ripgrep-backed source for blink.
- [x] `xzbdmw/colorful-menu.nvim` — colored completion menu.
- [ ] `andersevenrud/cmp-tmux` — tmux window content as completion source. You have it disabled.
- [ ] `milanglacier/minuet-ai.nvim` — AI edit prediction (OpenAI-compatible). Currently off for you.
- [ ] `fang2hou/blink-copilot` + `zbirenbaum/copilot.lua` — GitHub Copilot prediction. Currently off for you.
- [x] `folke/lazydev.nvim` — LSP + completion for your own Lua files (your config itself).

## editor.lua — editing behavior

- [ ] `olimorris/persisted.nvim` — session persistence (`:SessionToggle` etc.).
- [x] `m4xshen/autoclose.nvim` — auto-close brackets/quotes/strings.
- [x] `pteroctopus/faster.nvim` — fast-load mode for big files. On by default. Your settings do not override it.
- [x] `ojroques/nvim-bufdel` — smarter buffer deletion (`:BufDel` etc.).
- [x] `folke/flash.nvim` — character/word jump (partial replacement of hop/wilder/treehopper).
- [x] `numToStr/Comment.nvim` — `gc`-style comment toggling.
- [ ] `sindrets/diffview.nvim` — git diff UI.
- [] `echasnovski/mini.align` — `gv` block aligning.
- [x] `echasnovski/mini.cursorword` — highlight word under cursor.
- [ ] `smoka7/hop.nvim` — two-key word jump. You have it disabled. flash.nvim overlaps.
- [ ] `brenoprata10/nvim-highlight-colors` — hex color highlight under cursor.
- [ ] `romainl/vim-cool` — auto-indent / auto-shift.
- [x] `lambdalisue/suda.vim` — `:SudaRead` / `:SudaWrite` (sudo edit).
- [ ] `tpope/vim-sleuth` — auto-detect indent/tab options per filetype.
- [ ] `MagicDuck/grug-far.nvim` — file browser with git ops (alternate to telescope finders).

### Tree-sitter add-ons (core `nvim-treesitter/nvim-treesitter` is your item 4 — kept)

- [x] `nvim-treesitter/nvim-treesitter` — highlighting/parsing core.
- [x] `nvim-treesitter/nvim-treesitter-textobjects` — TS-aware `aw`, `af`, … textobjects.
- [x] `mfussenegger/nvim-treehopper` — TS-aware `c`/`o`/`a` jumping between nodes.
- [x] `andymass/vim-matchup` — smarter `%` matching (also disables built-in matchit/matchparen).
- [x] `windwp/nvim-ts-autotag` — auto-close tags in markup files.
- [x] `hiphish/rainbow-delimiters.nvim` — rainbow parens.
- [x] `nvim-treesitter/nvim-treesitter-context` — show current function/scope above cursor.
- [ ] `JoosepAlviste/nvim-ts-context-commentstring` — TS-based `--` commentstring.

## lang.lua — language packs

- [ ] `kevinhwang91/nvim-bqf` (+ `junegunn/fzf`) — quickfix UI with filters.
- [ ] `ray-x/go.nvim` (+ `ray-x/guihua.lua`) — Go tooling. You have it disabled.
- [x] `mrcjkb/rustaceanvim` — Rust tooling.
- [ ] `Saecki/crates.nvim` — Cargo crate explorer (`:Cargo`).
- [x] `MeanderingProgrammer/render-markdown.nvim` — render markdown/CodeCompanion output.
- [ ] `iamcco/markdown-preview.nvim` — markdown preview.
- [ ] `chrisbra/csv.vim` — CSV editing.

## tool.lua — git, terminal, search, debugging

- [x] `tpope/vim-fugitive` — git from Vim.
- [ ] `Bekaboo/dropbar.nvim` — dropbar file explorer (needs telescope deps + fzf-native).
- [x] `nvim-tree/nvim-tree.lua` — sidebar file tree.
- [x] `ibhagwan/smartyank.nvim` — auto-copy yanked text to system clipboard.
- [ ] `michaelb/sniprun` — run selected code in a shell. You have it disabled.
- [ ] `akinsho/toggleterm.nvim` — persistent named terminals.
- [] `folke/trouble.nvim` — diagnostics/locations list UI.
- [x] `folke/which-key.nvim` — keybinding cheat sheet on prefix.
- [ ] `olimorris/codecompanion.nvim` (+ `ravitemer/codecompanion-history.nvim`) — AI chat.
      Off for you (`use_chat=false`).
- [ ] `ibhagwan/fzf-lua` — fzf-based search backend. Off for you (`search_backend=telescope`).

### Fuzzy finder (your item 3 — kept)

Decision (2026-09-19): keep telescope, drop `tv.nvim` (see `fuzzy-finder-comparison.md`).
Option A confirmed: tabbed `search.nvim` UX.

Your ff/fp keymaps run through the `ayamir/search.nvim` module.
Option A keeps that tabbed UX. It needs `search.nvim` + `frecency` + `live-grep-args`.
Option B rebinds ff to `find_files` and fp to `live_grep_args`, dropping `search.nvim`.
Option A is chosen (confirmed 2026-09-19). The boxes below match it.

- [x] `nvim-telescope/telescope.nvim` — fuzzy finder core.
- [ ] `nvim-telescope/telescope-fzf-native.nvim` — dropped. The new config does not load the fzf extension.
- [x] `nvim-telescope/telescope-frecency.nvim` — Frecency tab in the file collection. Option A only.
- [x] `nvim-telescope/telescope-live-grep-args.nvim` — "Word in project" in the pattern collection. Needed by both options.
- [ ] `jvgrootveld/telescope-zoxide` — dropped (the dossier collection is dropped).
- [ ] `debugloop/telescope-undo.nvim` — dropped (the misc collection is dropped).
- [x] `ayamir/search.nvim` — implements the ff/fp keymaps. Option A only.
- [ ] `DrKJeff16/project.nvim` — dropped (the dossier collection is dropped).
- [ ] `aaronhallaert/advanced-git-search.nvim` (+ `tpope/vim-rhubarb`) — dropped (the git collection is dropped).

### Debugging

- [ ] `mfussenegger/nvim-dap` (+ `rcarriga/nvim-dap-ui`, `nvim-neotest/nvim-nio`) — debugger + UI.

## ui.lua — looks & statusline

- [x] `goolord/alpha-nvim` — splash screen (your item 1).
- [x] `Jint-lzxy/nvim` (branch `refactor/syntax-highlighting`, name `catppuccin`) —
      catppuccin-macchiato theme (your item 2).
- [x] `akinsho/bufferline.nvim` — buffer tabs.
- [x] `lewis6991/gitsigns.nvim` — git signs in the gutter.
- [x] `lukas-reineke/indent-blankline.nvim` — indentation guides.
- [x] `nvim-lualine/lualine.nvim` — statusline.
- [x] `karb94/neoscroll.nvim` — smooth scrolling.
- [ ] `rcarriga/nvim-notify` — notification toasts.
- [ ] `folke/paint.nvim` — `<leader>pp` palette picker.
- [ ] `mrjones2014/smart-splits.nvim` — open splits in the last-used direction.
- [ ] `folke/edgy.nvim` — edge windows (statusline/indent).
- [ ] `folke/todo-comments.nvim` (+ `nvim-lua/plenary.nvim`) — `-- TODO` collection.
- [x] `dstein64/nvim-scrollview` — scrollbar with minimap.

## Transitive dependencies (pulled in automatically, no config of their own)

`nvim-lua/plenary.nvim`, `nvim-tree/nvim-web-devicons`, `nvim-neotest/nvim-nio`.
Keep only if a selected plugin needs them.

## Your `lua/user/plugins` (carried over, not a selection)

`nvim-cmp` + `cmp-lsp-rimels` (completion), `mini.surround`, `im-select.nvim`,
`flash-zh.nvim`, `jieba.vim` (editor), `lammps.vim`, `lean.nvim` (lang), `focus.nvim` (ui).
Note: your user dir references `nvim-cmp`, but the module now ships `blink.cmp`.
If you drop blink, that user config breaks. If you keep blink, the `nvim-cmp` entry is dead weight.
Decide when picking above.
