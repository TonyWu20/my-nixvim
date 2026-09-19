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
- [x] `mason-org/mason.nvim` — package manager that *installs* LSP servers (your "installation?" part).
- [x] `mason-org/mason-lspconfig.nvim` — bridges Mason and LSP. nvimdots uses it to auto-install
  servers listed in `settings.lsp_deps` / `null_ls_deps` / `dap_deps` / `treesitter_deps`.
- [ ] `folke/neoconf.nvim` — one-shot LSP config generator (`NeoconfCreate`). Convenience only.
- [ ] `nvimdev/lspsaga.nvim` — LSP UI: code actions menu, code lens, diagnostic flythrough.
- [ ] `rachartier/tiny-inline-diagnostic.nvim` — inline diagnostic icons in the code.
- [ ] `joechrisellis/lsp-format-modifications.nvim` — LSP format only the lines you changed on save.
- [ ] `nvimtools/none-ls.nvim` (+ `jay-babu/mason-null-ls.nvim`) — run external formatters
  (clang_format, prettier, shfmt, stylua, vint…) as LSP.
- [ ] `saghen/blink.cmp` — autocompletion engine.
- [ ] `L3MON4D3/LuaSnip` (+ `rafamadriz/friendly-snippets`) — snippet engine + snippet pack.
- [ ] `f3fora/cmp-spell` — spell-based completion source.
- [ ] `kdheepak/cmp-latex-symbols` — LaTeX symbols in completion (only matters for LaTeX).
- [ ] `mikavilpas/blink-ripgrep.nvim` — ripgrep-backed source for blink.
- [ ] `xzbdmw/colorful-menu.nvim` — colored completion menu.
- [ ] `andersevenrud/cmp-tmux` — tmux window content as completion source. You have it disabled.
- [ ] `milanglacier/minuet-ai.nvim` — AI edit prediction (OpenAI-compatible). Currently off for you.
- [ ] `fang2hou/blink-copilot` + `zbirenbaum/copilot.lua` — GitHub Copilot prediction. Currently off for you.
- [ ] `folke/lazydev.nvim` — LSP + completion for your own Lua files (your config itself).

## editor.lua — editing behavior

- [ ] `olimorris/persisted.nvim` — session persistence (`:SessionToggle` etc.).
- [ ] `m4xshen/autoclose.nvim` — auto-close brackets/quotes/strings.
- [ ] `pteroctopus/faster.nvim` — fast-load mode for big files. On by default. Your settings do not override it.
- [ ] `ojroques/nvim-bufdel` — smarter buffer deletion (`:BufDel` etc.).
- [ ] `folke/flash.nvim` — character/word jump (partial replacement of hop/wilder/treehopper).
- [ ] `numToStr/Comment.nvim` — `gc`-style comment toggling.
- [ ] `sindrets/diffview.nvim` — git diff UI.
- [ ] `echasnovski/mini.align` — `gv` block aligning.
- [ ] `echasnovski/mini.cursorword` — highlight word under cursor.
- [ ] `smoka7/hop.nvim` — two-key word jump. You have it disabled. flash.nvim overlaps.
- [ ] `brenoprata10/nvim-highlight-colors` — hex color highlight under cursor.
- [ ] `romainl/vim-cool` — auto-indent / auto-shift.
- [ ] `lambdalisue/suda.vim` — `:SudaRead` / `:SudaWrite` (sudo edit).
- [ ] `tpope/vim-sleuth` — auto-detect indent/tab options per filetype.
- [ ] `MagicDuck/grug-far.nvim` — file browser with git ops (alternate to telescope finders).

### Tree-sitter add-ons (core `nvim-treesitter/nvim-treesitter` is your item 4 — kept)

- [x] `nvim-treesitter/nvim-treesitter` — highlighting/parsing core.
- [ ] `nvim-treesitter/nvim-treesitter-textobjects` — TS-aware `aw`, `af`, … textobjects.
- [ ] `mfussenegger/nvim-treehopper` — TS-aware `c`/`o`/`a` jumping between nodes.
- [ ] `andymass/vim-matchup` — smarter `%` matching (also disables built-in matchit/matchparen).
- [ ] `windwp/nvim-ts-autotag` — auto-close tags in markup files.
- [ ] `hiphish/rainbow-delimiters.nvim` — rainbow parens.
- [ ] `nvim-treesitter/nvim-treesitter-context` — show current function/scope above cursor.
- [ ] `JoosepAlviste/nvim-ts-context-commentstring` — TS-based `--` commentstring.

## lang.lua — language packs

- [ ] `kevinhwang91/nvim-bqf` (+ `junegunn/fzf`) — quickfix UI with filters.
- [ ] `ray-x/go.nvim` (+ `ray-x/guihua.lua`) — Go tooling. You have it disabled.
- [ ] `mrcjkb/rustaceanvim` — Rust tooling.
- [ ] `Saecki/crates.nvim` — Cargo crate explorer (`:Cargo`).
- [ ] `MeanderingProgrammer/render-markdown.nvim` — render markdown/CodeCompanion output.
- [ ] `iamcco/markdown-preview.nvim` — markdown preview.
- [ ] `chrisbra/csv.vim` — CSV editing.

## tool.lua — git, terminal, search, debugging

- [ ] `tpope/vim-fugitive` — git from Vim.
- [ ] `Bekaboo/dropbar.nvim` — dropbar file explorer (needs telescope deps + fzf-native).
- [ ] `nvim-tree/nvim-tree.lua` — sidebar file tree.
- [ ] `ibhagwan/smartyank.nvim` — auto-copy yanked text to system clipboard.
- [ ] `michaelb/sniprun` — run selected code in a shell. You have it disabled.
- [ ] `akinsho/toggleterm.nvim` — persistent named terminals.
- [ ] `folke/trouble.nvim` — diagnostics/locations list UI.
- [ ] `folke/which-key.nvim` — keybinding cheat sheet on prefix.
- [ ] `olimorris/codecompanion.nvim` (+ `ravitemer/codecompanion-history.nvim`) — AI chat.
  Off for you (`use_chat=false`).
- [ ] `ibhagwan/fzf-lua` — fzf-based search backend. Off for you (`search_backend=telescope`).

### Fuzzy finder (your item 3 — core kept)

- [x] `nvim-telescope/telescope.nvim` — fuzzy finder core.
- [ ] `nvim-telescope/telescope-fzf-native.nvim` — fuzz-algorithm speedup.
- [ ] `nvim-telescope/telescope-frecency.nvim` — frecency (recent+frequency) results.
- [ ] `nvim-telescope/telescope-live-grep-args.nvim` — live-grep with flags.
- [ ] `jvgrootveld/telescope-zoxide` — zoxide directory jumps.
- [ ] `debugloop/telescope-undo.nvim` — search in the undo tree.
- [ ] `ayamir/search.nvim` — integrated search module.
- [ ] `DrKJeff16/project.nvim` — project detection (feeds other pickers).
- [ ] `aaronhallaert/advanced-git-search.nvim` (+ `tpope/vim-rhubarb`) — git history/search pickers.

### Debugging

- [ ] `mfussenegger/nvim-dap` (+ `rcarriga/nvim-dap-ui`, `nvim-neotest/nvim-nio`) — debugger + UI.

## ui.lua — looks & statusline

- [x] `goolord/alpha-nvim` — splash screen (your item 1).
- [x] `Jint-lzxy/nvim` (branch `refactor/syntax-highlighting`, name `catppuccin`) —
  catppuccin-macchiato theme (your item 2).
- [ ] `akinsho/bufferline.nvim` — buffer tabs.
- [ ] `lewis6991/gitsigns.nvim` — git signs in the gutter.
- [ ] `lukas-reineke/indent-blankline.nvim` — indentation guides.
- [ ] `nvim-lualine/lualine.nvim` — statusline.
- [ ] `karb94/neoscroll.nvim` — smooth scrolling.
- [ ] `rcarriga/nvim-notify` — notification toasts.
- [ ] `folke/paint.nvim` — `<leader>pp` palette picker.
- [ ] `mrjones2014/smart-splits.nvim` — open splits in the last-used direction.
- [ ] `folke/edgy.nvim` — edge windows (statusline/indent).
- [ ] `folke/todo-comments.nvim` (+ `nvim-lua/plenary.nvim`) — `-- TODO` collection.
- [ ] `dstein64/nvim-scrollview` — scrollbar with minimap.

## Transitive dependencies (pulled in automatically, no config of their own)

`nvim-lua/plenary.nvim`, `nvim-tree/nvim-web-devicons`, `nvim-neotest/nvim-nio`.
Keep only if a selected plugin needs them.

## Your `lua/user/plugins` (carried over, not a selection)

`nvim-cmp` + `cmp-lsp-rimels` (completion), `mini.surround`, `im-select.nvim`,
`flash-zh.nvim`, `jieba.vim` (editor), `lammps.vim`, `lean.nvim` (lang), `focus.nvim` (ui).
Note: your user dir references `nvim-cmp`, but the module now ships `blink.cmp`.
If you drop blink, that user config breaks. If you keep blink, the `nvim-cmp` entry is dead weight.
Decide when picking above.
