# Plugin enable-set, settings ports, LSP servers, formatters, and runtime
# packages. The nixvim replacement for the old lazy.nvim specs + mason stack.
{ config, lib, pkgs, ... }:
let
  # Raw-lua helper for function values embedded in plugin settings.
  # Raw-Lua-code helper. The affected plugin options are typed strLua or
  # strLuaFn (or `maybeRaw str` for keymap actions), which accept a plain
  # string or a mkRaw value. mkRaw emits the code as unquoted Lua. A
  # nestedLiteralLua value (an attrset) is rejected by those types.
  nlua = lib.nixvim.mkRaw;
in
{
  # ------------------------------------------------------------------
  # Lazy-loading provider (replaces the lazy.nvim manager).
  # ------------------------------------------------------------------
  plugins.lz-n.enable = true;

  # ------------------------------------------------------------------
  # Colorscheme + UI
  # ------------------------------------------------------------------
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
      booleans = [ "bold" "italic" ];
    };
    settings.integrations = {
      blink_cmp = true;
      flash = true;
      fzf = true;
      gitsigns = true;
      indent_blankline = { enabled = true; colored_indent_levels = true; };
      mini = { enabled = true; };
      nvimtree = true;
      rainbow_delimiters = true;
      render_markdown = true;
      semantic_tokens = true;
      telescope = { enabled = true; style = "nvchad"; };
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

  plugins.alpha = {
    enable = true;
    lazyLoad.settings.event = "BufWinEnter";
    # Port of the old dashboard: the user's ASCII art + two search buttons.
    settings.layout = [
      {
        type = "text";
        val = [
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿"
          "⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿"
          "⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠿⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿⣿"
        ];
        opts = { position = "center"; hl = "AlphaHeader"; };
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  Find files";
            on_press = nlua "function() require('search').open({ collection = 'file' }) end";
            opts = { position = "center"; shortcut = "ff"; cursor = 5; width = 50; align_shortcut = "right"; };
          }
          {
            type = "button";
            val = "  Find patterns";
            on_press = nlua "function() require('search').open({ collection = 'pattern' }) end";
            opts = { position = "center"; shortcut = "fp"; cursor = 5; width = 50; align_shortcut = "right"; };
          }
        ];
      }
      {
        type = "text";
        val = "Have Fun with neovim";
        opts = { position = "center"; hl = "AlphaFooter"; };
      }
    ];
  };

  plugins.bufferline = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPre" "BufAdd" "BufNewFile" ];
    settings.options.always_show_bufferline = true;
    settings.options.close_command = "BufDel! %d";
    settings.options.right_mouse_command = "BufDel! %d";
    settings.options.diagnostics = "nvim_lsp";
  };
  plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "BufAdd" "BufNewFile" ];
  };
  plugins.gitsigns = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    settings.auto_attach = true;
    settings.current_line_blame = true;
    settings.signs = {
      add = { text = "┃"; };
      change = { text = "┃"; };
      delete = { text = "_"; };
      topdelete = { text = "‾"; };
      changedelete = { text = "~"; };
      untracked = { text = "┆"; };
    };
    # Buffer-scoped hunk maps (port of the old keymaps.lua M.gitsigns).
    settings.on_attach = nlua ''
      function(bufnr)
        local gitsigns = require('gitsigns')
        local function bmap(mode, lhs, fn, desc, expr)
          local o = { noremap = true, buffer = true, desc = desc }
          if expr then o.expr = true end
          vim.keymap.set(mode, lhs, fn, o)
        end
        bmap('n', ']g', function()
          if vim.wo.diff then return ']g' end
          vim.schedule(function() gitsigns.nav_hunk('next') end)
          return '<Ignore>'
        end, 'git: Goto next hunk', true)
        bmap('n', '[g', function()
          if vim.wo.diff then return '[g' end
          vim.schedule(function() gitsigns.nav_hunk('prev') end)
          return '<Ignore>'
        end, 'git: Goto prev hunk', true)
        bmap('n', '<leader>gs', function() gitsigns.stage_hunk() end, 'git: Toggle hunk')
        bmap('v', '<leader>gs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'git: Toggle hunk')
        bmap('n', '<leader>gr', function() gitsigns.reset_hunk() end, 'git: Reset hunk')
        bmap('v', '<leader>gr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'git: Reset hunk')
        bmap('n', '<leader>gR', function() gitsigns.reset_buffer() end, 'git: Reset buffer')
        bmap('n', '<leader>gp', function() gitsigns.preview_hunk() end, 'git: Preview hunk')
        bmap('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, 'git: Blame line')
        bmap('o', 'ih', function() gitsigns.select_hunk() end, 'git: Select hunk')
      end
    '';
  };
  plugins.indent-blankline = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
  };
  plugins.neoscroll = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    settings.hide_cursor = true;
    settings.stop_eof = true;
    settings.mappings = [
      "<C-u>"
      "<C-d>"
      "<C-b>"
      "<C-f>"
      "<C-y>"
      "<C-e>"
      "zt"
      "zz"
      "zb"
    ];
  };
  plugins.scrollview = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "BufAdd" "BufNewFile" ];
  };

  # ------------------------------------------------------------------
  # Editing
  # ------------------------------------------------------------------
  plugins.autoclose = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    settings.keys = {
      " " = { escape = false; close = true; pair = "()"; };
      "[" = { escape = false; close = true; pair = "[]"; };
      "{" = { escape = false; close = true; pair = "{}"; };
      "<" = { escape = true; close = true; pair = "<>"; enabled_filetypes = [ "rust" ]; };
      ">" = { escape = true; close = false; pair = "<>"; };
      ")" = { escape = true; close = false; pair = "()"; };
      "]" = { escape = true; close = false; pair = "[]"; };
      "}" = { escape = true; close = false; pair = "{}"; };
      "\"" = { escape = true; close = true; pair = "\"\""; };
      "`" = { escape = true; close = true; pair = "``"; };
      "'" = { escape = true; close = true; pair = "''"; disabled_filetypes = [ "rust" ]; };
    };
    settings.options.disabled_filetypes = [
      "alpha"
      "checkhealth"
      "diff"
      "help"
      "log"
      "NvimTree"
      "qf"
      "TelescopePrompt"
    ];
  };
  plugins.faster.enable = true; # eager: defers features on big files
  plugins.bufdelete = {
    enable = true;
    lazyLoad.settings.cmd = [ "BufDel" "BufDelAll" "BufDelOthers" ];
  };
  plugins.flash = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    settings.labels = "asdfghjklqwertyuiopzxcvbnm";
    settings.label.uppercase = true;
    settings.label.current = true;
    settings.label.distance = true;
    settings.modes.search.enabled = false;
    settings.modes.char = {
      enabled = true;
      autohide = false;
      jump_labels = true;
      multi_line = true;
      label.exclude = "hjkliardc";
    };
  };
  plugins.comment = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    settings.ignore = "^$";
  };
  plugins.mini-cursorword = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "BufAdd" "BufNewFile" ];
    settings.delay = 200;
  };
  plugins.vim-suda = {
    enable = true;
    lazyLoad.settings.cmd = [ "SudaRead" "SudaWrite" ];
  };

  # Treesitter: install the full Nix grammar set (superset of the old
  # ensure_installed list). highlight + indent via native APIs.
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
  };
  plugins.treesitter-textobjects = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "BufAdd" "BufNewFile" ];
    settings.select.lookahead = true;
    settings.select.selection_modes = {
      "@parameter.outer" = "v";
      "@function.outer" = "V";
      "@class.outer" = "<c-v>";
    };
    settings.move.set_jumps = true;
  };
  plugins.treesitter-context = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "BufAdd" "BufNewFile" ];
    settings.enable = true;
    settings.line_numbers = true;
    settings.max_lines = 3;
    settings.multiline_threshold = 20;
    settings.trim_scope = "outer";
    settings.mode = "cursor";
  };
  plugins.vim-matchup = {
    enable = true;
    # Port of the old vimscript-plugin globals (matchup_*). The plugin module
    # prefixes these settings into `globals.matchup_*` automatically.
    settings.transmute_enabled = 1;
    settings.surround_enabled = 1;
    settings.matchparen_offscreen = { method = "popup"; };
  };
  plugins.ts-autotag = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    settings.enable_close = true;
    settings.enable_rename = true;
    settings.enable_close_on_slash = false;
  };
  plugins.rainbow-delimiters.enable = true;

  # ------------------------------------------------------------------
  # Completion
  # ------------------------------------------------------------------
  plugins.blink-cmp = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" "InsertEnter" "CmdlineEnter" ];
    settings.snippets.preset = "default";
    settings.term.enabled = false;
    settings.appearance.nerd_font_variant = "normal";
    settings.fuzzy.implementation = "prefer_rust_with_warning";
    settings.cmdline.enabled = true;
    settings.cmdline.sources = nlua ''
      function()
        local t = vim.fn.getcmdtype()
        if t == '/' or t == '?' then return { 'buffer' } end
        if t == ':' or t == '@' then return { 'cmdline', 'path' } end
        return {}
      end
    '';
    settings.sources.default = [
      "lsp"
      "snippets"
      "path"
      "buffer"
      "ripgrep"
      "lazydev"
      "latex-symbols"
    ];
    settings.sources.providers = {
      lazydev = {
        name = "LazyDev";
        module = "lazydev.integrations.blink";
        score_offset = 100;
        enabled = nlua "function() return vim.bo.filetype == 'lua' end";
      };
      ripgrep = {
        name = "Ripgrep";
        module = "blink-ripgrep";
        max_items = 3;
        opts.prefix_min_len = 3;
      };
      latex-symbols = {
        name = "LaTeX";
        module = "blink-cmp-latex";
      };
      buffer = {
        opts.get_bufnrs = nlua ''
          function()
            return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
          end
        '';
      };
    };
    settings.keymap.preset = "none";
    settings.keymap."<C-p>" = [ "select_prev" "fallback" ];
    settings.keymap."<C-n>" = [ "select_next" "fallback" ];
    settings.keymap."<C-d>" = [ "scroll_documentation_up" "fallback" ];
    settings.keymap."<C-f>" = [ "scroll_documentation_down" "fallback" ];
    settings.keymap."<C-w>" = [ "cancel" "fallback" ];
    settings.keymap."<Tab>" = [ "select_next" "snippet_forward" "fallback" ];
    settings.keymap."<S-Tab>" = [ "select_prev" "snippet_backward" "fallback" ];
    settings.keymap."<CR>" = [ "accept" "fallback" ];
    settings.completion.ghost_text.enabled = false;
    settings.completion.list.max_items = 120;
    settings.completion.menu.border = "single";
    settings.completion.menu.scrollbar = false;
  };
  plugins.blink-ripgrep.enable = true;
  plugins.colorful-menu.enable = true;
  plugins.blink-cmp-latex.enable = true; # replaces the vendored symbol data
  plugins.lazydev = {
    enable = true;
    lazyLoad.settings.ft = "lua";
    settings.library = [
      "lazy.nvim"
      { path = "luvit-meta/library"; words = [ "vim%.uv" ]; }
    ];
  };

  # None-ls formatters. Each source auto-adds its nixpkgs binary to PATH.
  plugins.none-ls = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    sources = {
      formatting.clang_format = {
        enable = true;
        settings.filetypes = [ "c" "cpp" "objc" "objcpp" "cs" "cuda" "proto" ];
      };
      formatting.prettier = {
        enable = true;
        settings.filetypes = [
          "vue"
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
          "yaml"
          "html"
          "css"
          "scss"
          "sh"
          "markdown"
        ];
      };
      formatting.shfmt.enable = true;
      formatting.stylua.enable = true;
      diagnostics.vint.enable = true;
    };
  };
  plugins.lsp-format.enable = true; # format-on-save via LSP / none-ls
  plugins.lspconfig.enable = true; # nvim-lspconfig registry (server defaults)

  # ------------------------------------------------------------------
  # Language packs
  # ------------------------------------------------------------------
  plugins.rustaceanvim = {
    enable = true;
    lazyLoad.settings.ft = "rust";
    settings.dap = {
      adapter = false;
      configuration = false;
      autoload_configurations = false;
    };
    settings.server.standalone = true;
    settings.server.default_settings."rust-analyzer" = {
      checkOnSave = { allFeatures = true; command = "cargo check"; };
      procMacro = { enable = true; };
      completion = { autoimport = true; };
      files = { excludeDirs = [ ".direnv" ]; };
    };
  };
  plugins.render-markdown = {
    enable = true;
    lazyLoad.settings.ft = "markdown";
    settings.enabled = true;
    settings.max_file_size = 2.0;
    settings.debounce = 100;
    settings.render_modes = [ "n" "c" "t" ];
    settings.anti_conceal.enabled = true;
    settings.log_level = "error";
  };

  # ------------------------------------------------------------------
  # Tooling
  # ------------------------------------------------------------------
  plugins.fugitive = {
    enable = true;
    lazyLoad.settings.cmd = [ "Git" "G" ];
  };
  plugins.nvim-tree = {
    enable = true;
    lazyLoad.settings.cmd = [
      "NvimTreeToggle"
      "NvimTreeOpen"
      "NvimTreeFindFile"
      "NvimTreeFindFileToggle"
      "NvimTreeRefresh"
    ];
  };
  plugins.which-key = {
    enable = true;
    lazyLoad.settings.event = [ "CursorHold" "CursorHoldI" ];
    settings.preset = "classic";
    settings.triggers = [ { "<auto>" = { mode = "nixso"; }; } ];
  };
  plugins.web-devicons.enable = true;
  plugins.telescope = {
    enable = true;
    lazyLoad.settings.cmd = "Telescope";
    settings.defaults.vimgrep_arguments = [
      "rg"
      "--no-heading"
      "--with-filename"
      "--line-number"
      "--column"
      "--smart-case"
    ];
    settings.defaults.initial_mode = "insert";
    settings.defaults.scroll_strategy = "limit";
    settings.defaults.color_devicons = true;
    settings.defaults.layout_config.width = 0.85;
    settings.defaults.layout_config.height = 0.92;
    extensions = {
      frecency.enable = true;
      live-grep-args.enable = true;
      fzf-native.enable = false; # dropped per plugin-selection.md
    };
  };

  # ------------------------------------------------------------------
  # Language servers (replace Mason). nixpkgs binaries are added to PATH
  # automatically by each `lsp.servers.<name>` entry.
  # ------------------------------------------------------------------
  lsp.servers = {
    bashls.enable = true;
    jsonls.enable = true;
    lua_ls.enable = true;
    pylsp.enable = true;
    fish_lsp.enable = true;
    tinymist.enable = true;
    harper_ls = {
      enable = true;
      config = {
        cmd = [ "harper-ls" "--stdio" ];
        filetypes = [ "tex" "typst" ];
      };
    };
    nushell = {
      enable = true;
      config = {
        cmd = [ "nu" "--lsp" ];
        filetypes = [ "nu" ];
        single_file_support = true;
      };
    };
  };

  # LSP attach keymaps (port of the old LspAttach block). Registered on
  # `LspAttach` by the top-level `lsp` module; each map is buffer-local.
  lsp.keymaps = [
    { key = "gd"; lspBufAction = "definition"; mode = "n"; options.desc = "lsp: Goto definition"; }
    { key = "gD"; lspBufAction = "declaration"; mode = "n"; options.desc = "lsp: Goto declaration"; }
    { key = "gr"; lspBufAction = "references"; mode = "n"; options.desc = "lsp: References"; }
    { key = "gi"; lspBufAction = "implementation"; mode = "n"; options.desc = "lsp: Implementations"; }
    { key = "K"; lspBufAction = "hover"; mode = "n"; options.desc = "lsp: Show doc"; }
    { key = "gO"; lspBufAction = "document_symbol"; mode = "n"; options.desc = "lsp: Document outline"; }
    { key = "gs"; lspBufAction = "signature_help"; mode = "n"; options.desc = "lsp: Signature help"; }
    { key = "ga"; lspBufAction = "code_action"; mode = "n"; options.desc = "lsp: Code action for cursor"; }
    { key = "<leader>li"; mode = "n"; action = nlua "function() vim.lsp.buf.show_client_info() end"; options.desc = "lsp: Info"; }
    { key = "<leader>lr"; lspBufAction = "restart"; mode = "n"; options.desc = "lsp: Restart"; }
    {
      key = "<leader>ca";
      mode = "v";
      action = nlua "function() vim.lsp.buf.select_code_action() end";
      options.desc = "lsp: Code action for selection";
    }
  ];

  # ------------------------------------------------------------------
  # Plugins with no nixvim module.
  #
  # The first four are plain nixpkgs packages, pulled from
  # `pkgs.vimPlugins`.
  #
  # The last two have no nixpkgs package in the pinned revision, so
  # they are built from pinned source with `pkgs.vimUtils.buildVimPlugin`
  # + `pkgs.fetchFromGitHub` (rev + tarball sha256 pinned for
  # reproducibility).
  # ------------------------------------------------------------------
  extraPlugins =
    with pkgs.vimPlugins;
    [
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
