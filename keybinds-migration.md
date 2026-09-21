# Keybind migration: `~/nvimdots` (lazy.nvim) to Nixvim

Full audit of every old keybind against the new Nixvim repo. Old sources:
`lua/keymap/*`, `lua/modules/configs/lang/crates-keymap.lua`,
`lua/modules/configs/tool/dap/dap-keymap.lua`, `lua/core/event.lua`, and
`lua/user/plugins/*`.

Each keybind is one of three kinds:

- **MIGRATED**: present and equivalent in the new repo.
- **DROPPED**: its plugin is not installed here. Nothing was dropped just
  because it looked optional.
- **ADAPTED**: the key moved, was repurposed, or was fixed. A decision is
  noted.

New-repo sources: `keymaps.nix`, `plugins.nix` (`lsp.keymaps`, gitsigns
`on_attach`, telescope `settings.mappings`, which-key `settings`), and
`extra-lua.nix`.

Verification: headless `./result/bin/nvim` probes. 94 migrated keys probed
present and 62 dropped keys probed absent, with 0 failures. A live split test
ran `:SmartCursorMove*` through the lz-n stub and moved the window. A
`CursorHold` probe confirmed comment.nvim lazy-loads and registers
`gb gbc gc gb gco gcO gcA`.

Where each map lives:

- km: `keymaps.nix`
- lsp: `lsp.keymaps`
- gs: gitsigns `on_attach`
- tk: telescope extension `mappings`
- wk: which-key settings
- mod: a plugin module default
- builtin: Neovim 0.12 runtime default (`vim/_core/defaults.lua`)

---

## 1. Built-in keybinds (MIGRATED)

Ported verbatim from `editor.lua` and `ui.lua` into `keymaps.nix`.

- `<C-s>` n: `:w` silent
- `<C-s>` i: `<Esc>:w<CR>`
- `<C-q>` n: `:wq`
- `<C-q>` i: `<Esc>:wq<CR>`
- `<A-S-q>` n: `:q!`
- `<C-u>` i: `<C-G>u<C-U>`
- `<C-b>` i: `<Left>`
- `<C-a>` i: `<Esc>^i`
- `<C-b>` c: `<Left>`
- `<C-f>` c: `<Right>`
- `<C-a>` c: `<Home>`
- `<C-e>` c: `<End>`
- `<C-d>` c: `<Del>`
- `<C-h>` c: `<BS>`
- `<C-t>` c: `<C-R>=expand("%:p:h") . "/" <CR>`
- `J` `K` v: move line down / up
- `<` `>` v: outdent / indent
- `Y` `D` n: `y$` / `d$`
- `n` `N` n: `nzzzv` / `Nzzzv`
- `J` n: `mzJ\`z` join
- `<S-Tab>` n: `:normal za` fold
- `<Esc>` n: hide flash jump else `noh`
- `<leader>o` n: toggle spell `en_us`
- `<leader>bn` n: `:enew`
- `tn` `tk` `tj` `to` n: tab new / next / prev / only
- `<C-w>h/j/k/l` t: `<Cmd>wincmd {h,j,k,l}<CR>`
- `<Esc><Esc>` t: `<C-\><C-n>` leave terminal to normal. Old `tool.lua`
  grouped it under toggleterm, but the action is the builtin escape, so it is
  not toggleterm-specific and is kept.

`<C-h/j/k/l>` in normal mode are the smart-splits focus keys. See section 2.5.
They differ from the command-mode `<C-h>` backspace above. No conflict.

---

## 2. Plugin keybinds, MIGRATED (plugin is installed)

### 2.1 vim-suda
- `<A-s>` n: `:SudaWrite` [km]

### 2.2 nvim-treehopper
- `m` o: `:lua require('tsht').nodes()` [km]

### 2.3 nvim-bufdel
- `<A-q>` n: `:BufDel` [km]

### 2.4 bufferline.nvim
- `<A-i>` / `<A-o>` n: `BufferLineCycleNext` / `CyclePrev` [km]
- `<A-S-i>` / `<A-S-o>` n: `BufferLineMoveNext` / `MovePrev` [km]
- `<A-1>` to `<A-9>` n: `BufferLineGoToBuffer N` [km]
- `<leader>be` n: `BufferLineSortByExtension` [km]
- `<leader>bd` n: `BufferLineSortByDirectory` [km]

### 2.5 smart-splits.nvim, the reported breakage, now RESTORED
Enabled via `plugins.smart-splits` (nixpkgs `vimPlugins."smart-splits-nvim"`).
The 12 maps are in `keymaps.nix`. The `:Smart*` commands are lz-n `cmd` stubs.
So they fire on first press, even before `CursorHold` lazy-loads.

- `<C-h> <C-j> <C-k> <C-l>` n: `:SmartCursorMove{Left,Down,Up,Right}` [km]
- `<A-h> <A-j> <A-k> <A-l>` n: `:SmartResize{Left,Down,Up,Right}` [km]
- `<leader>Wh Wj Wk Wl` n: `:SmartSwap{Left,Down,Up,Right}` [km]

### 2.6 nvim-treesitter-textobjects
Maps are registered eagerly in `keymaps.nix`. Each action guards its call with
`pcall`. It degrades until the lazy plugin loads.

- `af` `if` x,o: select `@function.outer` / `inner`
- `ac` `ic` x,o: select `@class.outer` / `inner`
- `<leader>a` / `<leader>A` n: swap `@parameter.inner` / `outer`
- `][ ]] [[ []` n,x,o: next / prev start / end of `@function.outer`
- `]m ]M [m [M` n,x,o: next / prev start / end of `@class.outer`
- `;` n,x,o: repeat last move

### 2.7 vim-fugitive
- `gps` / `gpl` n: `:G push` / `:G pull` [km]
- `<leader>gG` n: `:Git` [km]

### 2.8 nvim-tree.lua
- `<leader>nf` n: `:NvimTreeFindFile` [km]
- `<leader>nr` n: `:NvimTreeRefresh` [km]

### 2.9 render-markdown.nvim
- `<F1>` n: `:RenderMarkdown toggle` [km]

### 2.10 lsp-format.nvim
- `<A-f>` n: `:FormatToggle` [km]
- `<A-S-f>` n: `:Format` [km]

The old repo defined these commands itself in `lua/modules/configs/completion/
formatting.lua`. Here the lsp-format.nvim plugin provides the same two
commands. The keys are unchanged.

### 2.11 telescope, live-grep-args, and search.nvim
- `<C-p>` n: `telescope.builtin.keymaps`, skip which-key `Þ` entries [km]
- `<leader>ff` n: search collection `file` [km]
- `<leader>fp` n: search collection `pattern` [km]
- `<leader>fs` v: live-grep the visual selection [km]
- `<leader>fc` n: telescope collections picker [km]
- `<leader>fr` n: `:Telescope resume` [km]
- `<C-k>` i (live-grep): auto-quote prompt [tk]
- `<C-i>` i (live-grep): auto-quote with `--iglob` [tk]

### 2.12 Comment operators
The old config mapped `gcc gbc gc gb` in n and `gc gb` in x. It used hand-
written `<Plug>(comment_*)` expr maps. Those maps are dropped from
`keymaps.nix`. The keys are covered two ways:

- `gc` n,x,o and `gcc` n: Neovim 0.12 built-in commenting (`vim._comment`),
  always present. [builtin]
- `gb` `gbc` n and `gc gb` x: comment.nvim default, lazy on `CursorHold`. [mod]
- `gco` `gcO` `gcA` n: comment.nvim extra default, lazy on `CursorHold`. [mod]

### 2.13 gitsigns.nvim, buffer scope, on_attach
Ported into `plugins.gitsigns.settings.on_attach`. `]g` and `[g` use expr so a
diff buffer passes the key through. `gs` and `gr` are buffer-local in n and v.
The hunk textobject is in o and x.

- `]g` / `[g` n: next / prev hunk [gs]
- `<leader>gs` n,v: stage hunk [gs]
- `<leader>gr` n,v: reset hunk [gs]
- `<leader>gR` n: reset buffer [gs]
- `<leader>gp` n: preview hunk [gs]
- `<leader>gb` n: blame line [gs]
- `ih` o,x: select hunk [gs]

### 2.14 LSP keymaps, set on LspAttach
All old `completion.lua M.lsp(buf)` maps. Two are gone because their plugins
are dropped. Those are `go` (trouble) and `<leader>lv` (tiny-inline-diagnostic).

- `gd` n: `Lspsaga peek_definition` [lsp]
- `gD` n: `Lspsaga goto_definition` [lsp]
- `gr` / `gR` n: `Lspsaga rename` / `++project` [lsp]
- `K` n: `Lspsaga hover_doc` [lsp]
- `ga` n,v: `Lspsaga code_action` [lsp]
- `gs` n: signature help, `lspBufAction` [lsp]
- `gh` / `gm` n: `lsp_references` / `lsp_implementations` [lsp]
- `gto` n: `lsp_document_symbols` [lsp]
- `g[` / `g]` n: `diagnostic_jump_prev` / `next` [lsp]
- `gci` / `gco` n: `incoming` / `outgoing_calls` [lsp]
- `<leader>lx` n: `show_line_diagnostics ++unfocus` [lsp]
- `<leader>lh` n: toggle inlay hint [lsp]
- `<leader>li` n: LSP info, 0.12 API [lsp]
- `<leader>lr` n: LSP restart, 0.12 API [lsp]

### 2.15 which-key.nvim (UI)
Ported the old `which-key.lua`. Kept `preset=classic`, `delay=300`, the
`<auto>` trigger in `nixso`, the `plugins` presets, `win` style, `expand=1`,
and the `spec` group labels. The old delay was `timeoutlen`.

Group labels are plain text. The old glyphs came from `modules.utils.icons`.
This repo does not ship that helper. So the glyphs are dropped. Labels keep
their meaning. Only groups whose plugins survive are kept.

- `<leader>g`: Git
- `<leader>b`: Buffer
- `<leader>W`: Window
- `<leader>l`: Lsp
- `<leader>f`: Fuzzy Find
- `<leader>n`: Nvim Tree

---

## 3. ADAPTED keybinds (a decision was made)

- `<C-n>`: was edgy left panel, now `:NvimTreeToggle`. edgy is not installed.
  The tree role moved to nvim-tree. Same key, new target.
- `<leader>nt`: new, `:NvimTreeToggle`. Sits next to the repurposed `<C-n>`.
- `<A-f>` / `<A-S-f>`: keys unchanged. The provider changed from the old
  hand-written `completion/formatting.lua` module to the lsp-format.nvim
  plugin, which defines the same `:Format` / `:FormatToggle` commands.
- smart-splits trigger: added 12 `cmd` stubs on top of the idle events.
  The focus keys now work on first press, not only after idle.
- `gs`: now `lspBufAction="signature_help"` instead of a callback.
- `<leader>li`: was `:LspInfo`, now an active-client summary.
  `:LspInfo` was removed in 0.12.
- `<leader>lr`: was `:LspRestart`, now stop client then `vim.lsp.start`.
  `vim.lsp.buf.restart` was removed in 0.12.
- comment maps: now from comment.nvim defaults, not custom expr maps.
  Equivalent, and avoids duplicate registrations.
- gitsigns `ih`: old mode was `ox`, now `o` plus `x`. Restored to match.
- which-key: 11 glyph groups became 6 plain groups. Dropped groups whose
  plugins are gone, and dropped the glyphs.

---

## 4. DROPPED keybinds (plugin is not installed)

These plugins are confirmed absent from the Nixvim pack dir.

The old user overlays in `lua/user/keymap/` already disabled some of these
(`hop`, `sniprun`, `codecompanion`) via `= false` entries. That matches the
new repo.

- persisted, diffview, hop, grug-far, markdown-preview
- trouble, sniprun, toggleterm, nvim-dap, dapui
- codecompanion, crates, tiny-inline-diagnostic, fzf-lua
- lazy.nvim (replaced by lz.n)
- flash-zh.nvim, jieba.vim (user plugins, `lua/user/plugins`)

### 4.1 lazy.nvim, replaced by lz.n, no `:Lazy` UI
- `<leader>ph` n: `:Lazy`
- `<leader>ps` n: `:Lazy sync`
- `<leader>pu` n: `:Lazy update`
- `<leader>pi` n: `:Lazy install`
- `<leader>pl` n: `:Lazy log`
- `<leader>pc` n: `:Lazy check`
- `<leader>pd` n: `:Lazy debug`
- `<leader>pp` n: `:Lazy profile`
- `<leader>pr` n: `:Lazy restore`
- `<leader>px` n: `:Lazy clean`

### 4.2 persisted.nvim
- `<leader>ss` n: `:SessionSave`
- `<leader>sl` n: `:SessionLoad`
- `<leader>sd` n: `:SessionDelete`

### 4.3 diffview.nvim
- `<leader>gd` n: `:DiffviewOpen`
- `<leader>gD` n: `:DiffviewClose`

### 4.4 hop.nvim
- `<leader>w` n,v: `:HopWordMW`
- `<leader>j` n,v: `:HopLineMW`
- `<leader>k` n,v: `:HopLineMW`
- `<leader>c` n,v: `:HopChar1MW`
- `<leader>C` n,v: `:HopChar2MW`

### 4.5 grug-far
- `<leader>Ss` n: open search and replace
- `<leader>Sp` n,v: open prefilled or with selection
- `<leader>Sf` n: open with current file

### 4.6 MarkdownPreview.nvim
- `<F12>` n: `:MarkdownPreviewToggle`

### 4.7 trouble.nvim
- `gt` n: `:Trouble diagnostics toggle`
- `<leader>lw` n: `:Trouble diagnostics toggle`
- `<leader>lp` n: `:Trouble project_diagnostics toggle`
- `<leader>ld` n: `:Trouble diagnostics toggle filter.buf=0`
- `go` n: `:Trouble symbols toggle win.position=right`

### 4.8 sniprun.nvim
- `<leader>r` v: `:SnipRun`
- `<leader>r` n: `:%SnipRun`

### 4.9 toggleterm.nvim
- `<C-\>` n,i,t: horizontal terminal
- `<A-\>` n,i,t: vertical terminal
- `<F5>` n,i,t: vertical terminal
- `<A-d>` n,i,t: float terminal
- `<leader>gg` n: toggle lazygit terminal

### 4.10 nvim-dap and dapui
- `<F6>` n: continue
- `<F7>` n: stop
- `<F8>` n: toggle breakpoint
- `<F9>` n: step into
- `<F10>` n: step out
- `<F11>` n: step over
- `<leader>db` n: set breakpoint with condition
- `<leader>dc` n: run to cursor
- `<leader>dl` n: run last
- `<leader>do` n: open REPL
- `<leader>dC` n: close debug UI
- `K` n,v: eval under cursor (from `dap-keymap.lua`)

### 4.11 CodeCompanion and edgy
- `<leader>cs` n: select chat model
- `<leader>cc` n,v: edgy right panel
- `<leader>ck` n,v: `:CodeCompanionActions`
- `<leader>ca` v: `:CodeCompanionChat Add`

### 4.12 crates.nvim (Rust)
- `<leader>ct cr cv cf cd` n: toggle / reload / versions / features / deps
- `<leader>cu` n,v: update current or selected crate
- `<leader>cU` n,v: upgrade current or selected crate
- `<leader>ca cA` n: update or upgrade all
- `<leader>cH cR cD cC` n: homepage / repo / docs / crates.io

The old config set `<leader>cs`, `<leader>ca`, and `<leader>cv` for both
CodeCompanion and crates. Both are dropped. So that old conflict is gone.

### 4.13 tiny-inline-diagnostic
- `<leader>lv` n: toggle virtual inline diagnostics

### 4.14 search.nvim collections not ported
`extra-lua.nix` defines only the `file` and `pattern` collections. These pickers
have no target collection, so they are dropped.

- `<leader>fg` n: git collection
- `<leader>fd` n: dossier collection
- `<leader>fm` n: misc collection

### 4.15 fzf-lua, search backend is now telescope
- `<leader>fR` n: fzf-lua resume

### 4.16 Carried-over user plugins, not installed
These come from `lua/user/plugins/`. None are in the Nixvim pack.

- `s` n,x,o: flash-zh Chinese jump (`flash-zh.nvim`)
- jieba word keymaps via `jieba_vim_keymap` (`jieba.vim`, Chinese tokenizer)

---

## 5. Buffer-local and event-scoped keymaps (old `core/event.lua`)

Two more maps lived outside the keymap files.

- `q` n, buffer-local on `qf/help/man/notify/nofile/terminal/prompt` and
  friends: `:close`. No plugin dependency. MIGRATED to `extra-lua.nix`
  (ported verbatim from the old `core/event.lua` autocmd).
- `<leader>h` n, buffer-local on c/cpp files: `:ClangdSwitchSourceHeader`.
  DROPPED. The command comes from a clangd setup, and no C/C++ LSP server
  is in `lsp.servers` now. The old map even pointed at
  `ClangdSwitchSourceHeader`, which the old config never defined. The real
  command was `LspClangdSwitchSourceHeader`. If a C/C++ LSP comes back,
  restore this map.

---

## 6. Keybind conflicts

No two maps in the new config share the same lhs and mode. Two overlaps are
worth knowing about.

- smart-splits `<A-h/j/k/l>` and edgy edge-resize `<A-h/j/k/l>`. Edgy is not
  installed, so smart-splits owns those keys.
- comment.nvim `gc`/`gb` operators and lspsaga `gci`/`gco`. This coexistence
  is faithful to the old config. A quick `gci` resolves to the lspsaga map,
  and a slow `gc` starts the comment operator. `timeoutlen` is 300.

`which-key` shows six plain-text groups for the surviving prefixes. The old
nerd-font glyphs are dropped because this repo does not ship the icon helper.

---

## 7. Easy things to misread

`<leader>fr` (Telescope resume) is kept. Only its fzf-lua twin `<leader>fR`
is dropped.

`<C-h/j/k/l>` are the focus keys in section 2.5. They are not the command-mode
`<C-h>` backspace from section 1.

`<C-w>h/j/k/l` in terminal mode (section 1) are untouched. smart-splits only
maps normal mode.
