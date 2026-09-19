# Global keymaps. Port of lua/keymaps.lua (command-style maps + the
# function-based search/telescope maps). LSP-attach maps live in
# `lsp.keymaps`; the gitsigns buffer maps live in
# `plugins.gitsigns.settings.on_attach`.
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
    # ---- Save & quit ----
    { key = "<C-s>"; mode = "n"; action = ":w<CR>"; options.desc = "edit: Save file"; }
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
    { key = "<S-Tab>"; mode = "n"; action = ":normal za<CR>"; options.desc = "edit: Toggle code fold"; }
    { key = "<Esc>"; mode = "n"; action = ":noh<CR>"; options.desc = "edit: Clear search highlight"; }
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

    # ---- vim-fugitive ----
    { key = "gps"; mode = "n"; action = ":G push<CR>"; options.desc = "git: Push"; }
    { key = "gpl"; mode = "n"; action = ":G pull<CR>"; options.desc = "git: Pull"; }
    { key = "<leader>gG"; mode = "n"; action = ":Git<CR>"; options.desc = "git: Open fugitive"; }

    # ---- nvim-tree ----
    { key = "<leader>nf"; mode = "n"; action = ":NvimTreeFindFile<CR>"; options.desc = "filetree: Find file"; }
    { key = "<leader>nr"; mode = "n"; action = ":NvimTreeRefresh<CR>"; options.desc = "filetree: Refresh"; }
    { key = "<leader>nt"; mode = "n"; action = ":NvimTreeToggle<CR>"; options.desc = "filetree: Toggle tree"; }

    # ---- render-markdown ----
    { key = "<F1>"; mode = "n"; action = ":RenderMarkdown toggle<CR>"; options.desc = "tool: Toggle markdown preview"; }

    # ---- formatter (on-save is handled by lsp-format) ----
    { key = "<A-S-f>"; mode = "n"; action = ":LspFormat<CR>"; options.desc = "formatter: Format buffer manually"; }

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
    {
      key = "<C-p>";
      mode = "n";
      action = nlua "function() require('telescope.builtin').keys() end";
      options.desc = "tool: Toggle command panel";
    }
  ];
}
