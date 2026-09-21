# Global keymaps. Faithful port of the old nvimdots `lua/keymap/` files:
#   editor.lua     -> builtins + editor plugin maps
#   completion.lua -> formatter maps (the LSP-attach maps live in
#                    `lsp.keymaps` in plugins.nix. The gitsigns buffer maps
#                    live in `plugins.gitsigns.settings.on_attach`)
#   lang.lua       -> render-markdown
#   tool.lua       -> fugitive, nvim-tree, telescope
#   ui.lua         -> buffer/tab/terminal builtins, bufdel, bufferline,
#                    smart-splits
#   init.lua       -> lazy.nvim manager maps (dropped: lz-n replaces it)
#
# Keymaps of plugins that are NOT installed in this repo are intentionally
# absent. The full migrated/dropped/conflicted classification, with the
# plugin each keybind depends on, is in ../keybinds-migration.md.
{ lib, ... }:
let
  # Raw-Lua-code helper. The affected plugin options are typed strLua or
  # strLuaFn (or `maybeRaw str` for keymap actions), which accept a plain
  # string or a mkRaw value. mkRaw emits the code as unquoted Lua. A
  # nestedLiteralLua value (an attrset) is rejected by those types.
  nlua = lib.nixvim.mkRaw;
in
{
  keymaps = [
    # ---- Save & quit (builtin) ----
    { key = "<C-s>"; mode = "n"; action = ":w<CR>"; options.desc = "edit: Save file"; options.silent = true; }
    { key = "<C-q>"; mode = "n"; action = ":wq<CR>"; options.desc = "edit: Save and quit"; }
    { key = "<A-S-q>"; mode = "n"; action = ":q!<CR>"; options.desc = "edit: Force quit"; }

    # ---- Insert mode ----
    { key = "<C-u>"; mode = "i"; action = "<C-G>u<C-U>"; options.desc = "edit: Delete previous block"; }
    { key = "<C-b>"; mode = "i"; action = "<Left>"; options.desc = "edit: Move cursor to left"; }
    { key = "<C-a>"; mode = "i"; action = "<Esc>^i"; options.desc = "edit: Move cursor to line start"; }
    { key = "<C-s>"; mode = "i"; action = "<Esc>:w<CR>"; options.desc = "edit: Save file"; }
    { key = "<C-q>"; mode = "i"; action = "<Esc>:wq<CR>"; options.desc = "edit: Save and quit"; }

    # ---- Command mode ----
    { key = "<C-b>"; mode = "c"; action = "<Left>"; }
    { key = "<C-f>"; mode = "c"; action = "<Right>"; }
    { key = "<C-a>"; mode = "c"; action = "<Home>"; }
    { key = "<C-e>"; mode = "c"; action = "<End>"; }
    { key = "<C-d>"; mode = "c"; action = "<Del>"; }
    { key = "<C-h>"; mode = "c"; action = "<BS>"; }
    {
      key = "<C-t>";
      mode = "c";
      action = ''<C-R>=expand("%:p:h") . "/" <CR>'';
      options.desc = "edit: Complete path of current file";
    }

    # ---- Visual mode ----
    { key = "J"; mode = "v"; action = ":m '>+1<CR>gv=gv"; options.desc = "edit: Move this line down"; }
    { key = "K"; mode = "v"; action = ":m '<-2<CR>gv=gv"; options.desc = "edit: Move this line up"; }
    { key = "<"; mode = "v"; action = "<gv"; options.desc = "edit: Decrease indent"; }
    { key = ">"; mode = "v"; action = ">gv"; options.desc = "edit: Increase indent"; }

    # ---- Suckless ----
    { key = "Y"; mode = "n"; action = "y$"; options.desc = "edit: Yank text to EOL"; }
    { key = "D"; mode = "n"; action = "d$"; options.desc = "edit: Delete text to EOL"; }
    { key = "n"; mode = "n"; action = "nzzzv"; options.desc = "edit: Next search result"; }
    { key = "N"; mode = "n"; action = "Nzzzv"; options.desc = "edit: Prev search result"; }
    { key = "J"; mode = "n"; action = "mzJ`z"; options.desc = "edit: Join next line"; }
    { key = "<S-Tab>"; mode = "n"; action = ":normal za<CR>"; options.desc = "edit: Toggle code fold"; options.silent = true; }
    # Old: keymap/helpers.flash_esc_or_noh — hide active flash.nvim jump
    # labels on Esc, otherwise clear the search highlight (flash.nvim is
    # installed here, so the branch matters).
    {
      key = "<Esc>";
      mode = "n";
      action =
        nlua ''
          function()
            local flash_active, state = pcall(function()
              return require("flash.plugins.char").state
            end)
            if flash_active and state then
              state:hide()
            else
              pcall(vim.cmd.noh)
            end
          end
        '';
      options.desc = "edit: Clear search highlight";
      options.silent = true;
    }
    { key = "<leader>o"; mode = "n"; action = ":setlocal spell! spelllang=en_us<CR>"; options.desc = "edit: Toggle spell check"; }

    # ---- suda.vim ----
    { key = "<A-s>"; mode = "n"; action = ":SudaWrite<CR>"; options.desc = "edit: Save file using sudo"; }

    # ---- nvim-treehopper ----
    { key = "m"; mode = "o"; action = ":lua require('tsht').nodes()<CR>"; options.desc = "jump: Operate across syntax tree"; }

    # ---- nvim-bufdel ----
    { key = "<A-q>"; mode = "n"; action = ":BufDel<CR>"; options.desc = "buffer: Close current"; }

    # ---- bufferline ----
    { key = "<A-i>"; mode = "n"; action = ":BufferLineCycleNext<CR>"; options.desc = "buffer: Switch to next"; }
    { key = "<A-o>"; mode = "n"; action = ":BufferLineCyclePrev<CR>"; options.desc = "buffer: Switch to prev"; }
    { key = "<A-S-i>"; mode = "n"; action = ":BufferLineMoveNext<CR>"; options.desc = "buffer: Move current to next"; }
    { key = "<A-S-o>"; mode = "n"; action = ":BufferLineMovePrev<CR>"; options.desc = "buffer: Move current to prev"; }
    { key = "<A-1>"; mode = "n"; action = ":BufferLineGoToBuffer 1<CR>"; }
    { key = "<A-2>"; mode = "n"; action = ":BufferLineGoToBuffer 2<CR>"; }
    { key = "<A-3>"; mode = "n"; action = ":BufferLineGoToBuffer 3<CR>"; }
    { key = "<A-4>"; mode = "n"; action = ":BufferLineGoToBuffer 4<CR>"; }
    { key = "<A-5>"; mode = "n"; action = ":BufferLineGoToBuffer 5<CR>"; }
    { key = "<A-6>"; mode = "n"; action = ":BufferLineGoToBuffer 6<CR>"; }
    { key = "<A-7>"; mode = "n"; action = ":BufferLineGoToBuffer 7<CR>"; }
    { key = "<A-8>"; mode = "n"; action = ":BufferLineGoToBuffer 8<CR>"; }
    { key = "<A-9>"; mode = "n"; action = ":BufferLineGoToBuffer 9<CR>"; }
    { key = "<leader>be"; mode = "n"; action = ":BufferLineSortByExtension<CR>"; options.desc = "buffer: Sort by extension"; }
    { key = "<leader>bd"; mode = "n"; action = ":BufferLineSortByDirectory<CR>"; options.desc = "buffer: Sort by directory"; }

    # ---- Builtin: new buffer & tab pages (old keymap/ui.lua) ----
    { key = "<leader>bn"; mode = "n"; action = ":enew<CR>"; options.desc = "buffer: New"; options.silent = true; }
    { key = "tn"; mode = "n"; action = ":tabnew<CR>"; options.desc = "tab: Create a new tab"; options.silent = true; }
    { key = "tk"; mode = "n"; action = ":tabnext<CR>"; options.desc = "tab: Move to next tab"; options.silent = true; }
    { key = "tj"; mode = "n"; action = ":tabprevious<CR>"; options.desc = "tab: Move to previous tab"; options.silent = true; }
    { key = "to"; mode = "n"; action = ":tabonly<CR>"; options.desc = "tab: Only keep current tab"; options.silent = true; }

    # ---- Builtin: window focus in terminal mode (old keymap/ui.lua) ----
    { key = "<C-w>h"; mode = "t"; action = "<Cmd>wincmd h<CR>"; options.desc = "window: Focus left"; options.silent = true; }
    { key = "<C-w>l"; mode = "t"; action = "<Cmd>wincmd l<CR>"; options.desc = "window: Focus right"; options.silent = true; }
    { key = "<C-w>j"; mode = "t"; action = "<Cmd>wincmd j<CR>"; options.desc = "window: Focus down"; options.silent = true; }
    { key = "<C-w>k"; mode = "t"; action = "<Cmd>wincmd k<CR>"; options.desc = "window: Focus up"; options.silent = true; }
    # Old keymap/tool.lua: leave terminal with <Esc><Esc>. Not
    # toggleterm-specific. The action is the builtin escape sequence.
    { key = "<Esc><Esc>"; mode = "t"; action = "<C-\\><C-n>"; options.desc = "terminal: Leave to normal"; options.silent = true; }

    # ---- smart-splits: directional split management (old keymap/ui.lua) ----
    # The `:Smart*` user commands are registered by the plugin's own plugin
    # file on load. lz-n's `cmd` triggers (see plugins.nix) make them work
    # even before the first CursorHold fires.
    { key = "<A-h>"; mode = "n"; action = ":SmartResizeLeft<CR>"; options.desc = "window: Resize -3 horizontally"; options.silent = true; }
    { key = "<A-j>"; mode = "n"; action = ":SmartResizeDown<CR>"; options.desc = "window: Resize -3 vertically"; options.silent = true; }
    { key = "<A-k>"; mode = "n"; action = ":SmartResizeUp<CR>"; options.desc = "window: Resize +3 vertically"; options.silent = true; }
    { key = "<A-l>"; mode = "n"; action = ":SmartResizeRight<CR>"; options.desc = "window: Resize +3 horizontally"; options.silent = true; }
    { key = "<C-h>"; mode = "n"; action = ":SmartCursorMoveLeft<CR>"; options.desc = "window: Focus left"; options.silent = true; }
    { key = "<C-j>"; mode = "n"; action = ":SmartCursorMoveDown<CR>"; options.desc = "window: Focus down"; options.silent = true; }
    { key = "<C-k>"; mode = "n"; action = ":SmartCursorMoveUp<CR>"; options.desc = "window: Focus up"; options.silent = true; }
    { key = "<C-l>"; mode = "n"; action = ":SmartCursorMoveRight<CR>"; options.desc = "window: Focus right"; options.silent = true; }
    { key = "<leader>Wh"; mode = "n"; action = ":SmartSwapLeft<CR>"; options.desc = "window: Move window leftward"; options.silent = true; }
    { key = "<leader>Wj"; mode = "n"; action = ":SmartSwapDown<CR>"; options.desc = "window: Move window downward"; options.silent = true; }
    { key = "<leader>Wk"; mode = "n"; action = ":SmartSwapUp<CR>"; options.desc = "window: Move window upward"; options.silent = true; }
    { key = "<leader>Wl"; mode = "n"; action = ":SmartSwapRight<CR>"; options.desc = "window: Move window rightward"; options.silent = true; }

    # ---- treesitter-textobjects (old keymap/editor.lua) ----
    # Port of the old keymap callbacks. The plugin ships no default keymaps,
    # so these must be defined here (per the nixvim module's docs). The
    # pcall guards degrade gracefully until the lazy plugin loads. The
    # `editxo:` / `editn:` / `editnxo:` desc prefixes are the exact strings
    # from the old config, kept verbatim (typos included).
    {
      key = "af";
      mode = [ "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.select")
            if ok then m.select_textobject("@function.outer", "textobjects") end
          end
        '';
      options.desc = "editxo: Select function.outer";
      options.silent = true;
    }
    {
      key = "if";
      mode = [ "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.select")
            if ok then m.select_textobject("@function.inner", "textobjects") end
          end
        '';
      options.desc = "editxo: Select function.inner";
      options.silent = true;
    }
    {
      key = "ac";
      mode = [ "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.select")
            if ok then m.select_textobject("@class.outer", "textobjects") end
          end
        '';
      options.desc = "editxo: Select class.outer";
      options.silent = true;
    }
    {
      key = "ic";
      mode = [ "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.select")
            if ok then m.select_textobject("@class.inner", "textobjects") end
          end
        '';
      options.desc = "editoxo: Select class.inner";
      options.silent = true;
    }
    {
      key = "<leader>a";
      mode = "n";
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.swap")
            if ok then m.swap_next("@parameter.inner") end
          end
        '';
      options.desc = "editn: Swap parameter.inner";
      options.silent = true;
    }
    {
      key = "<leader>A";
      mode = "n";
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.swap")
            if ok then m.swap_next("@parameter.outer") end
          end
        '';
      options.desc = "editn: Swap parameter.outer";
      options.silent = true;
    }
    {
      key = "][";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_next_start("@function.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to next function.outer start";
      options.silent = true;
    }
    {
      key = "]m";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_next_start("@class.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to next class.outer start";
      options.silent = true;
    }
    {
      key = "]]";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_next_end("@function.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to next function.outer end";
      options.silent = true;
    }
    {
      key = "]M";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_next_end("@class.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to next class.outer end";
      options.silent = true;
    }
    {
      key = "[[";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_previous_start("@function.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to previous function.outer start";
      options.silent = true;
    }
    {
      key = "[m";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_previous_start("@class.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to previous class.outer start";
      options.silent = true;
    }
    {
      key = "[]";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_previous_end("@function.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to previous function.outer end";
      options.silent = true;
    }
    {
      key = "[M";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.move")
            if ok then m.goto_previous_end("@class.outer", "textobjects") end
          end
        '';
      options.desc = "editnxo: Move to previous class.outer end";
      options.silent = true;
    }
    {
      key = ";";
      mode = [ "n" "x" "o" ];
      action =
        nlua ''
          function()
            local ok, m = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
            if ok then m.repeat_last_move_next() end
          end
        '';
      options.desc = "editnxo: Repeat last move";
      options.silent = true;
    }

    # ---- vim-fugitive ----
    { key = "gps"; mode = "n"; action = ":G push<CR>"; options.desc = "git: Push"; }
    { key = "gpl"; mode = "n"; action = ":G pull<CR>"; options.desc = "git: Pull"; }
    { key = "<leader>gG"; mode = "n"; action = ":Git<CR>"; options.desc = "git: Open fugitive"; }

    # ---- nvim-tree ----
    # Port of the old tool.lua maps: `nf` (find file) and `nr` (refresh).
    # The old "filetree: Toggle" was `<C-n>` via edgy's left panel. edgy is
    # dropped in this config, so the same key now drives nvim-tree's native
    # toggle. `<leader>nt` keeps the toggle on the leader prefix too.
    { key = "<leader>nf"; mode = "n"; action = ":NvimTreeFindFile<CR>"; options.desc = "filetree: Find file"; }
    { key = "<leader>nr"; mode = "n"; action = ":NvimTreeRefresh<CR>"; options.desc = "filetree: Refresh"; }
    { key = "<leader>nt"; mode = "n"; action = ":NvimTreeToggle<CR>"; options.desc = "filetree: Toggle tree"; }
    { key = "<C-n>"; mode = "n"; action = ":NvimTreeToggle<CR>"; options.desc = "filetree: Toggle tree (was edgy's left panel in nvimdots)"; }

    # ---- render-markdown ----
    { key = "<F1>"; mode = "n"; action = ":RenderMarkdown toggle<CR>"; options.desc = "tool: Toggle markdown preview"; }

    # ---- formatter (on-save is handled by lsp-format) ----
    # lsp-format.nvim provides `:Format` / `:FormatToggle`. There is no
    # `:LspFormat` user command in this build.
    { key = "<A-f>"; mode = "n"; action = ":FormatToggle<CR>"; options.desc = "formatter: Toggle format on save"; options.silent = true; }
    { key = "<A-S-f>"; mode = "n"; action = ":Format<CR>"; options.desc = "formatter: Format buffer manually"; options.silent = true; }

    # ---- telescope (resume; the rest are the function maps below) ----
    { key = "<leader>fr"; mode = "n"; action = ":Telescope resume<CR>"; options.desc = "tool: Resume last search"; }

    # ---- search.nvim / telescope function maps ----
    {
      key = "<leader>ff";
      mode = "n";
      action = nlua "function() require('search').open({ collection = 'file' }) end";
      options.desc = "tool: Find files";
    }
    {
      key = "<leader>fp";
      mode = "n";
      action = nlua "function() require('search').open({ collection = 'pattern' }) end";
      options.desc = "tool: Find patterns";
    }
    {
      key = "<leader>fs";
      mode = "v";
      action =
        nlua ''
          function()
            local ok, lga = pcall(require, "telescope-live-grep-args.shortcuts")
            if ok then lga.grep_visual_selection() end
          end
        '';
      options.desc = "tool: Grep visual selection";
    }
    # Old: helpers.picker("keymaps", { lhs_filter = ... }) on the telescope
    # backend == `telescope.builtin.keymaps` with a `lhs_filter`. The `Þ`
    # filter excludes which-key's synthetic entries. The earlier port used
    # the nonexistent `telescope.builtin.keys`. The picker is `keymaps`.
    {
      key = "<C-p>";
      mode = "n";
      action =
        nlua ''
          function()
            require('telescope.builtin').keymaps({
              lhs_filter = function(lhs)
                return not string.find(lhs, "Þ")
              end,
            })
          end
        '';
      options.desc = "tool: Toggle command panel";
      options.silent = true;
    }
    # Old: helpers.telescope_collections(get_dropdown()) — lists the
    # search.nvim collections. With this repo's extra-lua.nix the
    # collections reduce to `file` and `pattern` (the git/dossier/misc
    # collections were dropped with their extensions. See
    # keybinds-migration.md), so the picker lists two entries.
    {
      key = "<leader>fc";
      mode = "n";
      action =
        nlua ''
          function()
            local ok_tabs, tabs = pcall(require, "search.tabs")
            if not ok_tabs then return end
            local actions = require("telescope.actions")
            local state = require("telescope.actions.state")
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local collections = vim.tbl_keys(tabs.collections)
            pickers.new(require("telescope.themes").get_dropdown(), {
              prompt_title = "Telescope Collections",
              finder = finders.new_table({ results = collections }),
              sorter = conf.generic_sorter(),
              attach_mappings = function(bufnr)
                actions.select_default:replace(function()
                  actions.close(bufnr)
                  local selection = state.get_selected_entry()
                  require("search").open({ collection = selection[1] })
                end)
                return true
              end,
            }):find()
          end
        '';
      options.desc = "tool: Open Telescope collections";
      options.silent = true;
    }
  ];
}
