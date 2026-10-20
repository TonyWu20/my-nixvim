# Aggregator for the plugin tree. The five nvimdots categories
# live in the sub-directories, one .nix file per plugin.
# The leftovers below (colorscheme, LSP servers and keymaps, raw
# extra plugin packages) are non-plugin config that used to sit
# in the single plugins.nix file.
{ lib, pkgs, ... }:
let
  nlua = lib.nixvim.mkRaw;
in
{
  imports = [
    ./completion
    ./editor
    ./lang
    ./tool
    ./ui
  ];

  # The lazy-load provider that backs every lazyLoad spec.
  # Not one of the five nvimdots plugin categories.
  plugins.lz-n.enable = true;

  # --- colorscheme ---
  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "macchiato";
    settings.term_colors = true;
    settings.styles = {
      comments = [ "italic" ];
      functions = [ "bold" ];
      keywords = [ "italic" ];
      operators = [ "bold" ];
      conditionals = [ "bold" ];
      loops = [ "bold" ];
      booleans = [
        "bold"
        "italic"
      ];
    };
    settings.integrations = {
      blink_cmp = true;
      flash = true;
      fzf = true;
      gitsigns = true;
      indent_blankline = {
        enabled = true;
        colored_indent_levels = true;
      };
      mini = {
        enabled = true;
      };
      nvimtree = true;
      rainbow_delimiters = true;
      render_markdown = true;
      semantic_tokens = true;
      telescope = {
        enabled = true;
        style = "nvchad";
      };
      treesitter = true;
      treesitter_context = true;
      which_key = true;
    };
    # Port of the old highlight_overrides.all function (receives the palette).
    settings.custom_highlights = nlua ''
      function(cp)
        return {
          NormalFloat = { fg = cp.text, bg = cp.mantle },
          FloatBorder = { fg = cp.mantle, bg = cp.mantle },
          CursorLineNr = { fg = cp.green },
          DiagnosticVirtualTextError = { bg = cp.none },
          DiagnosticVirtualTextWarn = { bg = cp.none },
          DiagnosticVirtualTextInfo = { bg = cp.none },
          DiagnosticVirtualTextHint = { bg = cp.none },
          LspInfoBorder = { link = "FloatBorder" },
          Pmenu = { fg = cp.overlay2, bg = cp.base },
          PmenuBorder = { fg = cp.surface1, bg = cp.base },
          PmenuSel = { bg = cp.green, fg = cp.base },
          CmpItemAbbr = { fg = cp.overlay2 },
          CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
          CmpDoc = { link = "NormalFloat" },
          CmpDocBorder = { fg = cp.surface1, bg = cp.mantle },
        }
      end
    '';
  };

  # --- language servers (replace Mason) ---
  lsp.servers = {
    bashls.enable = true;
    jsonls.enable = true;
    lua_ls.enable = true;
    pylsp.enable = true;
    fish_lsp.enable = true;
    tinymist.enable = true;
    nixd = {
      enable = true;
      config.filetypes = [ "nix" ];
    };
    nil_ls = {
      enable = true;
      config.filetypes = [ "nix" ];
    };
    taplo.enable = true;
    harper_ls = {
      enable = true;
      config = {
        cmd = [
          "harper-ls"
          "--stdio"
        ];
        filetypes = [
          "tex"
          "typst"
        ];
      };
    };
    texlab = {
      enable = true;
      config = {
        build = {
          executable = "latexmk";
          # The -xelatex flag tells latexmk to use xelatex engine
          args = [
            "-xelatex"
            "-interaction=nonstopmode"
            "-synctex=1"
            "%f"
          ];
          onSave = true;
        };
        chktex = {
          onOpenAndSave = true;
          onEdit = false;
        };
      };
    };
    nushell = {
      enable = true;
      config = {
        cmd = [
          "nu"
          "--lsp"
        ];
        filetypes = [ "nu" ];
        single_file_support = true;
      };
    };
  };

  # --- LSP attach keymaps ---
  lsp.keymaps = [
    {
      key = "gd";
      mode = "n";
      action = ":Lspsaga peek_definition<CR>";
      options.desc = "lsp: Preview definition";
    }
    {
      key = "gD";
      mode = "n";
      action = ":Lspsaga goto_definition<CR>";
      options.desc = "lsp: Goto definition";
    }
    {
      key = "gr";
      mode = "n";
      action = ":Lspsaga rename<CR>";
      options.desc = "lsp: Rename in file range";
    }
    {
      key = "gR";
      mode = "n";
      action = ":Lspsaga rename ++project<CR>";
      options.desc = "lsp: Rename in project range";
    }
    {
      key = "K";
      mode = "n";
      action = ":Lspsaga hover_doc<CR>";
      options.desc = "lsp: Show doc";
    }
    {
      key = "ga";
      mode = "n";
      action = ":Lspsaga code_action<CR>";
      options.desc = "lsp: Code action for cursor";
    }
    {
      key = "ga";
      mode = "v";
      action = ":Lspsaga code_action<CR>";
      options.desc = "lsp: Code action for cursor";
    }
    {
      key = "gs";
      lspBufAction = "signature_help";
      mode = "n";
      options.desc = "lsp: Signature help";
    }
    {
      key = "gh";
      mode = "n";
      action = ":Telescope lsp_references<CR>";
      options.desc = "lsp: Show references";
    }
    {
      key = "gm";
      mode = "n";
      action = ":Telescope lsp_implementations<CR>";
      options.desc = "lsp: Show implementations";
    }
    {
      key = "gto";
      mode = "n";
      action = ":Telescope lsp_document_symbols<CR>";
      options.desc = "lsp: Document outline";
    }
    {
      key = "g[";
      mode = "n";
      action = ":Lspsaga diagnostic_jump_prev<CR>";
      options.desc = "lsp: Prev diagnostic";
    }
    {
      key = "g]";
      mode = "n";
      action = ":Lspsaga diagnostic_jump_next<CR>";
      options.desc = "lsp: Next diagnostic";
    }
    {
      key = "gci";
      mode = "n";
      action = ":Lspsaga incoming_calls<CR>";
      options.desc = "lsp: Show incoming calls";
    }
    {
      key = "gco";
      mode = "n";
      action = ":Lspsaga outgoing_calls<CR>";
      options.desc = "lsp: Show outgoing calls";
    }
    {
      key = "<leader>lx";
      mode = "n";
      action = ":Lspsaga show_line_diagnostics ++unfocus<CR>";
      options.desc = "lsp: Line diagnostic";
    }
    {
      key = "<leader>lh";
      mode = "n";
      action = nlua "function() local on = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) vim.lsp.inlay_hint.enable(not on, { bufnr = 0 }) vim.notify(on and 'Inlay hint disabled' or 'Inlay hint enabled', vim.log.levels.INFO, { title = 'LSP Inlay Hint' }) end";
      options.desc = "lsp: Toggle inlay hints";
    }
    # 0.12: `show_client_info` was removed. Show a summary of the active
    # client(s) instead (id, name, command, root dir).
    {
      key = "<leader>li";
      mode = "n";
      action = nlua "function() local a=vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }); if #a==0 then vim.notify('No LSP client', vim.log.levels.WARN) return end local L={} for _,c in ipairs(a) do local src = (c.config and c.config.cmd) or c.cmd local cmd = type(src)=='table' and table.concat(src,' ') or tostring(src) table.insert(L, ('Client %s [id=%d]'):format(c.name, c.id)) table.insert(L, '  cmd: '..cmd) table.insert(L, '  root_dir: '..tostring(c.root_dir)) end vim.notify(table.concat(L, string.char(10)), vim.log.levels.INFO, { title = 'LSP' }) end";
      options.desc = "lsp: Info";
    }
    # 0.12: `vim.lsp.buf.restart` was removed. Stop the active client(s) with
    # the `Client:stop()` method (the `stop_client` fn is deprecated), then
    # `vim.lsp.start` re-attaches via the servers nixvim enabled.
    # `LspAttach` fires again, so this autocmd re-registers the keymaps.
    {
      key = "<leader>lr";
      mode = "n";
      action = nlua "function() local a=vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }); if #a==0 then vim.notify('No LSP client to restart', vim.log.levels.WARN) return end for _,c in ipairs(a) do local cfg=vim.deepcopy(vim.lsp.config[c.name] or {}) cfg.name=c.name cfg.root_dir=c.root_dir or vim.fn.getcwd() c:stop() vim.lsp.start(cfg, {}) end end";
      options.desc = "lsp: Restart";
    }
  ];

  # --- raw extra plugin packages (no nixvim module) ---
  extraPlugins = with pkgs.vimPlugins; [
    # --- nixpkgs packages ---
    smartyank-nvim # auto-copy on yank
    mini-surround
    focus-nvim
    lean-nvim

    # --- built from pinned source (not in nixpkgs) ---
    (pkgs.vimUtils.buildVimPlugin {
      pname = "search.nvim";
      version = "00a9d7ad";
      src = pkgs.fetchFromGitHub {
        owner = "ayamir";
        repo = "search.nvim";
        rev = "00a9d7adfeb0d5e1966561674753d8ea8f911fec";
        sha256 = "0dazcpwjclqhgzrcvmqqk7fm96320zz5004acxmhinryzazww9nm";
      };
      doCheck = false; # plugin depends on telescope at load time
      meta = {
        description = "nvim plugin that adds tabs for telescope search";
        homepage = "https://github.com/ayamir/search.nvim";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-treehopper";
      version = "e3861c02";
      src = pkgs.fetchFromGitHub {
        owner = "mfussenegger";
        repo = "nvim-treehopper";
        rev = "e3861c0231631c6af317d6746bb78fdb428a58f3";
        sha256 = "0bb9ns1ndkbf40663fp9d0k861id8af45c4xnrrwc0jr3355y7s0";
      };
      doCheck = false; # plugin depends on telescope at load time
      meta = {
        description = "Region selection with hints on the AST nodes of a document";
        homepage = "https://github.com/mfussenegger/nvim-treehopper";
      };
    })
  ];
}
