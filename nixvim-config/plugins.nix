# Plugin enable-set, settings ports, LSP servers, formatters, and runtime
# packages. The nixvim replacement for the old lazy.nvim specs + mason stack.
{ lib, pkgs, ... }:
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

  plugins.alpha = {
    enable = true;
    lazyLoad.settings.event = "BufWinEnter";
    # Port of the old nvimdots dashboard (lua/modules/configs/ui/alpha.lua):
    # the user's ASCII art, the two search.nvim buttons, and the dynamic
    # footer. The old layout's spacing is preserved:
    #   top gap      = ceil((winheight - occupied) * 0.25), where occupied is
    #                  19 art lines + 2*2 buttons + 2 head padding (the old
    #                  header_padding, recomputed at draw time)
    #   2 blank lines between the art and the buttons (old head_butt_padding)
    #   1 blank line between the buttons and the footer (old foot_butt_padding)
    # alpha.nvim evaluates a section's `val` when it is a function, so the
    # top gap and the footer are Lua functions inside the layout.
    #
    # The old footer showed the nvim version plus plugin count and startuptime
    # from `require("lazy").stats()`. Nixvim's lazy-load provider is lz-n
    # (native packadd), which has no stats API, so the ported footer shows
    # the nvim version and the plugin count from `nvim_get_runtime_file` over
    # the pack path (start + opt dirs) and drops the "in Mms" timing.
    settings.layout = [
      {
        type = "padding";
        val = nlua ''
          function()
            local occupied = 19 + 2 * 2 + 2
            return math.max(0, math.ceil((vim.fn.winheight(0) - occupied) * 0.25))
          end
        '';
      }
      {
        type = "text";
        val = [
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿"
          "⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿"
          "⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿"
        ];
        opts = {
          position = "center";
          hl = "AlphaHeader";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  Find files";
            on_press = nlua "function() require('search').open({ collection = 'file' }) end";
            opts = {
              position = "center";
              shortcut = "ff";
              cursor = 5;
              width = 50;
              align_shortcut = "right";
            };
          }
          {
            type = "button";
            val = "  Find patterns";
            on_press = nlua "function() require('search').open({ collection = 'pattern' }) end";
            opts = {
              position = "center";
              shortcut = "fp";
              cursor = 5;
              width = 50;
              align_shortcut = "right";
            };
          }
        ];
      }
      {
        type = "padding";
        val = 1;
      }
      {
        type = "text";
        val = nlua ''
          function()
            local v = vim.version()
            local n = 0
            local ok, count = pcall(function()
              return #vim.api.nvim_get_runtime_file("pack/*/start/*", true)
                + #vim.api.nvim_get_runtime_file("pack/*/opt/*", true)
            end)
            if ok then n = count end
            return " \239\128\132  Have Fun with neovim"
              .. "  \239\128\168 v" .. v.major .. "." .. v.minor .. "." .. v.patch
              .. "  \239\130\150 " .. n .. " plugins"
          end
        '';
        opts = {
          position = "center";
          hl = "AlphaFooter";
        };
      }
    ];
  };

  plugins.bufferline = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufAdd"
      "BufNewFile"
    ];
    settings.options.always_show_bufferline = true;
    settings.options.close_command = "BufDel! %d";
    settings.options.right_mouse_command = "BufDel! %d";
    settings.options.diagnostics = "nvim_lsp";
  };
  # Statusline. The nixvim lualine defaults (mode/branch/filename/encoding/
  # progress/location) have no LSP client-name component, so the active
  # server is invisible. The old nvimdots statusline
  # (lua/modules/configs/ui/lualine.lua) rendered a custom `components.lsp`
  # that listed the attached server names next to the diagnostics count, so
  # that indicator is ported into `lualine_c` here: `filename` keeps the
  # default section-c entry, `diagnostics` restores the old E/W/I/H counts,
  # and the raw component lists the active LSP server name(s).
  plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
    settings.sections.lualine_c = [
      "filename"
      "diagnostics"
      (nlua "function() local ft=vim.bo.filetype if ft=='' then return '' end local names={} for _,c in ipairs(vim.lsp.get_clients({bufnr=0})) do local fts=c.config.filetypes or {} if vim.fn.index(fts,ft)~= -1 then names[#names+1]=c.name end end if #names==0 then return '' end local seen={} local uniq={} for _,n in ipairs(names) do if not seen[n] then seen[n]=true uniq[#uniq+1]=n end end return 'LSP['..table.concat(uniq, ', ')..']' end")
    ];
  };
  plugins.gitsigns = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    settings.auto_attach = true;
    settings.current_line_blame = true;
    settings.signs = {
      add = {
        text = "┃";
      };
      change = {
        text = "┃";
      };
      delete = {
        text = "_";
      };
      topdelete = {
        text = "‾";
      };
      changedelete = {
        text = "~";
      };
      untracked = {
        text = "┆";
      };
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
        bmap('x', 'ih', function() gitsigns.select_hunk() end, 'git: Select hunk')
      end
    '';
  };
  plugins.indent-blankline = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
  };
  plugins.neoscroll = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
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
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
  };
  # smart-splits.nvim: directional split navigation (left/right/up/down
  # instead of wider/narrower/taller/shorter). Restores the old
  # keymap/ui.lua maps:
  #   <C-h/j/k/l> focus a split        (:SmartCursorMove*)
  #   <A-h/j/k/l> resize a split by 3  (:SmartResize*)
  #   <leader>W{h,j,k,l} swap windows  (:SmartSwap*)
  # The old spec was lazy on CursorHold/CursorHoldI. The same events are
  # kept. The `cmd` triggers add the 12 `:Smart*` commands so the keymaps
  # in keymaps.nix work on first press instead of waiting for the first
  # CursorHold.
  #
  # DECISION (2026-10): this plugin was `[ ]` in plugin-selection.md and was
  # not in the initial nixvim port. It is added now because the user expects
  # the old `<C-h/j/k/l>` split-focus keys to work. If this decision is
  # reversed, remove this block, the 12 smart-splits keymaps in keymaps.nix,
  # and the `<leader>W` which-key group below.
  plugins.smart-splits = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    lazyLoad.settings.cmd = [
      "SmartCursorMoveDown"
      "SmartCursorMoveLeft"
      "SmartCursorMoveRight"
      "SmartCursorMoveUp"
      "SmartResizeDown"
      "SmartResizeLeft"
      "SmartResizeRight"
      "SmartResizeUp"
      "SmartSwapDown"
      "SmartSwapLeft"
      "SmartSwapRight"
      "SmartSwapUp"
    ];
    # Port of the old lua/modules/configs/ui/splits.lua. The values equal
    # the plugin defaults. They are stated explicitly so an upstream change
    # cannot shift the feel.
    settings.default_amount = 3;
    settings.ignored_buftypes = [
      "nofile"
      "quickfix"
      "prompt"
    ];
    settings.ignored_filetypes = [ "NvimTree" ];
  };

  # ------------------------------------------------------------------
  # Editing
  # ------------------------------------------------------------------
  plugins.autoclose = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    settings.keys = {
      " " = {
        escape = false;
        close = true;
        pair = "()";
      };
      "[" = {
        escape = false;
        close = true;
        pair = "[]";
      };
      "{" = {
        escape = false;
        close = true;
        pair = "{}";
      };
      "<" = {
        escape = true;
        close = true;
        pair = "<>";
        enabled_filetypes = [ "rust" ];
      };
      ">" = {
        escape = true;
        close = false;
        pair = "<>";
      };
      ")" = {
        escape = true;
        close = false;
        pair = "()";
      };
      "]" = {
        escape = true;
        close = false;
        pair = "[]";
      };
      "}" = {
        escape = true;
        close = false;
        pair = "{}";
      };
      "\"" = {
        escape = true;
        close = true;
        pair = "\"\"";
      };
      "`" = {
        escape = true;
        close = true;
        pair = "``";
      };
      "'" = {
        escape = true;
        close = true;
        pair = "''";
        disabled_filetypes = [ "rust" ];
      };
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
    lazyLoad.settings.cmd = [
      "BufDel"
      "BufDelAll"
      "BufDelOthers"
    ];
  };
  plugins.flash = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
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
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    settings.ignore = "^$";
  };
  plugins.mini-cursorword = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
    settings.delay = 200;
  };
  plugins.vim-suda = {
    enable = true;
    lazyLoad.settings.cmd = [
      "SudaRead"
      "SudaWrite"
    ];
  };

  # tpope/vim-sleuth: auto-detects indent/tab options per filetype. Port of
  # the old editor.lua spec: lazy on BufNewFile/BufReadPost/BufFilePost, no
  # settings table. The module defaults (heuristics on) already match.
  plugins.sleuth = {
    enable = true;
    lazyLoad.settings.event = [
      "BufNewFile"
      "BufReadPost"
      "BufFilePost"
    ];
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
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
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
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
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
    settings.matchparen_offscreen = {
      method = "popup";
    };
  };
  plugins.ts-autotag = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    # No settings: the plugin's defaults (enable_close = true,
    # enable_rename = true, enable_close_on_slash = false) already match
    # our requirements. Use `settings.opts.*` if we ever need overrides.
  };
  plugins.rainbow-delimiters.enable = true;

  # ------------------------------------------------------------------
  # Completion
  # ------------------------------------------------------------------
  plugins.blink-cmp = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "InsertEnter"
      "CmdlineEnter"
    ];
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
      "latex-symbols"
    ];
    # lazydev is a per-filetype source, not a global default. Its module
    # (lazydev.integrations.blink) only lands on package.path once lazydev.nvim
    # is loaded (ft = "lua"). blink requires the module for every provider in
    # `sources.default` on InsertEnter, so a global lazydev entry would crash
    # on any non-lua buffer. Registering it for the lua filetype only keeps the
    # completion available there while leaving other buffers crash-free.
    settings.sources.per_filetype = nlua ''
      {
        lua = { "lazydev", inherit_defaults = true },
      }
    '';
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
    settings.keymap."<C-p>" = [
      "select_prev"
      "fallback"
    ];
    settings.keymap."<C-n>" = [
      "select_next"
      "fallback"
    ];
    settings.keymap."<C-d>" = [
      "scroll_documentation_up"
      "fallback"
    ];
    settings.keymap."<C-f>" = [
      "scroll_documentation_down"
      "fallback"
    ];
    settings.keymap."<C-w>" = [
      "cancel"
      "fallback"
    ];
    settings.keymap."<Tab>" = [
      "select_next"
      "snippet_forward"
      "fallback"
    ];
    settings.keymap."<S-Tab>" = [
      "select_prev"
      "snippet_backward"
      "fallback"
    ];
    settings.keymap."<CR>" = [
      "accept"
      "fallback"
    ];
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
      {
        path = "luvit-meta/library";
        words = [ "vim%.uv" ];
      }
    ];
  };

  # None-ls formatters. Each source auto-adds its nixpkgs binary to PATH.
  plugins.none-ls = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    sources = {
      formatting.clang_format = {
        enable = true;
        settings.filetypes = [
          "c"
          "cpp"
          "objc"
          "objcpp"
          "cs"
          "cuda"
          "proto"
        ];
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

  # nvimdev/lspsaga: LSP UI (code actions, diagnostic flythrough, hover,
  # rename, call hierarchy). Port of the old lua/modules/configs/completion/
  # lspsaga.lua, lazy-loaded on LspAttach as before.
  #
  # Functional settings are ported verbatim. The icon-glyph fields that
  # nvimdots pulled from its modules.utils.icons table (ui.kind, ui.imp_sign,
  # ui.expand, ui.collapse, ui.code_action, ui.actionfix,
  # symbol_in_winbar.separator) are dropped: web-devicons (enabled above)
  # supplies the lspkind glyphs lspsaga falls back to.
  #
  # Nixvim warns that `implement` wants `symbol_in_winbar` enabled. The old
  # config deliberately ran implement on with the winbar breadcrumbs off, so
  # the port keeps that combination and accepts the build warning.
  #
  # hover.open_cmd uses the old core.settings external_browser default.
  plugins.lspsaga = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    settings = {
      symbol_in_winbar.enable = false;
      callhierarchy.layout = "float";
      callhierarchy.keys = {
        edit = "e";
        vsplit = "v";
        split = "s";
        tabe = "t";
        quit = "q";
        shuttle = "[]";
        toggle_or_req = "u";
        close = "<Esc>";
      };
      code_action = {
        num_shortcut = true;
        only_in_cursor = false;
        show_server_name = true;
        extend_gitsigns = false;
        keys = {
          quit = "q";
          exec = "<CR>";
        };
      };
      diagnostic = {
        show_code_action = true;
        jump_num_shortcut = true;
        max_width = 0.5;
        max_height = 0.6;
        text_hl_follow = true;
        border_follow = true;
        extend_relatedInformation = true;
        show_layout = "float";
        show_normal_height = 10;
        max_show_width = 0.9;
        max_show_height = 0.6;
        diagnostic_only_current = false;
        keys = {
          exec_action = "r";
          quit = "q";
          toggle_or_jump = "<CR>";
          quit_in_show = [
            "q"
            "<Esc>"
          ];
        };
      };
      hover = {
        max_width = 0.45;
        max_height = 0.7;
        open_link = "gl";
        open_cmd = "silent ! chrome-cli open";
      };
      implement = {
        enable = true;
        sign = true;
        virtual_text = false;
        priority = 100;
      };
      lightbulb = {
        enable = false;
        sign = true;
        virtual_text = false;
        debounce = 10;
        sign_priority = 20;
      };
      rename = {
        in_select = false;
        auto_save = false;
        project_max_width = 0.5;
        project_max_height = 0.5;
        keys = {
          quit = "<C-c>";
          exec = "<CR>";
          select = "x";
        };
      };
      beacon = {
        enable = true;
        frequency = 12;
      };
      ui = {
        border = "single";
        devicon = true;
        title = true;
        lines = [
          "┗"
          "┣"
          "┃"
          "━"
          "┏"
        ];
      };
      scroll_preview = {
        scroll_down = "<C-d>";
        scroll_up = "<C-u>";
      };
      request_timeout = 3000;
    };
  };

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
      checkOnSave = {
        allFeatures = true;
        command = "cargo check";
      };
      procMacro = {
        enable = true;
      };
      completion = {
        autoimport = true;
      };
      files = {
        excludeDirs = [ ".direnv" ];
      };
    };
  };
  plugins.render-markdown = {
    enable = true;
    lazyLoad.settings.ft = "markdown";
    settings.enabled = true;
    settings.max_file_size = 2.0;
    settings.debounce = 100;
    settings.render_modes = [
      "n"
      "c"
      "t"
    ];
    settings.anti_conceal.enabled = true;
    settings.log_level = "error";
  };

  # ------------------------------------------------------------------
  # Tooling
  # ------------------------------------------------------------------
  plugins.fugitive = {
    enable = true;
    lazyLoad.settings.cmd = [
      "Git"
      "G"
    ];
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
    # Port of the NvimTreeAutoClose autocmd from the old core/event.lua:
    # quit when the tree is the only remaining window in the tab.
    autoClose = true;
  };
  plugins.which-key = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    settings.preset = "classic";
    # Which-key v3.x trigger specs use the v2 format: `<auto>` (auto-
    # generate trigger entries from your keymaps) plus a `mode` field.
    # The plugin's own default is the positional form
    # `{ { "<auto>", mode = "nxso" } }`; Nix attrset literals have no
    # integer keys, so the positional element is written with its named
    # field instead: `lhs` is a valid v2 spec field and parses to the
    # same mapping (`mapping.lhs = "<auto>"`). `nixso` = n,i,x,s,o: the
    # plugin default `nxso` plus insert mode. The old v1 shape
    # `{ "<auto>" = { mode = "nixso" } }` was rejected with "Invalid
    # field `<auto>`" in `:checkhealth which-key`.
    settings.triggers = [
      {
        lhs = "<auto>";
        mode = "nixso";
      }
    ];
    # Port of the old lua/modules/configs/tool/which-key.lua: delay, window
    # style, expand, the builtin preset plugins, and the prefix group
    # labels. The old group labels carried nerd-font glyphs from
    # modules.utils.icons, which this config does not ship. Plain-text
    # groups keep the same structure. The groups for dropped plugins
    # (Debug, Session, Search-S, Chat, Package) are not ported.
    settings.delay = 300; # the old delay was `vim.o.timeoutlen` (300 here)
    settings.expand = 1;
    settings.win = {
      border = "none";
      padding = [
        1
        2
      ];
      wo.winblend = 0;
    };
    settings.plugins = {
      marks = true;
      registers = true;
      spelling = {
        enabled = true;
        suggestions = 20;
      };
      presets = {
        motions = false;
        operators = false;
        text_objects = true;
        windows = true;
        nav = true;
        z = true;
        g = true;
      };
    };
    settings.spec = [
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
      {
        __unkeyed-1 = "<leader>b";
        group = "Buffer";
      }
      {
        __unkeyed-1 = "<leader>W";
        group = "Window";
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "Lsp";
      }
      {
        __unkeyed-1 = "<leader>f";
        group = "Fuzzy Find";
      }
      {
        __unkeyed-1 = "<leader>n";
        group = "Nvim Tree";
      }
    ];
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
      # Port of the old lua/modules/configs/tool/telescope.lua extension opts.
      frecency = {
        enable = true;
        settings.show_scores = true;
        settings.show_unindexed = true;
        settings.ignore_patterns = [
          "*.git/*"
          "*/tmp/*"
        ];
      };
      # Port of the old live_grep_args extension, including the two prompt-mode
      # keybinds. The map values are Lua functions built at runtime, so the
      # whole `mappings` table is raw Lua.
      live-grep-args = {
        enable = true;
        settings.auto_quoting = true;
        # The old keybinds. `quote_prompt` builds the key handler at setup
        # time, so the value must be a Lua expression, not a statement.
        # `require` is cached, so the two calls are cheap.
        settings.mappings = nlua ''
          {
            i = {
              ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
            },
          }
        '';
      };
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

  # LSP attach keymaps. Port of M.lsp from the old keymap/completion.lua,
  # now routed through lspsaga. Registered on `LspAttach` by the top-level
  # `lsp` module; each map is buffer-local. lspsaga lazy-loads on the same
  # event, so its `:Lspsaga` user command is available when these maps fire;
  # `:Telescope` is registered by telescope's own lazy-load cmd trigger.
  #
  # Diffs vs the previous 0.12-only set (all per the old nvimdots config):
  # `gd` previews the definition via lspsaga (old: plain goto); `gD` goes to
  # the definition (old: declaration); `gr` renames via lspsaga (old:
  # references, which moved to `gh`); `gm`/`gto` replace `gi`/`gO` with
  # telescope pickers. `ga` replaces the old `<leader>ca` for code
  # actions. It maps in n and v modes as two entries, since the
  # keymap option takes one mode per entry. New: `g[`, `g]`, `gci`,
  # `gco`, `<leader>lx`, `<leader>lh`.
  # `<leader>li`/`<leader>lr` keep the 0.12 rewrites below. The old
  # virtual-lines toggle (`<leader>lv`) is dropped with
  # tiny-inline-diagnostic.
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
