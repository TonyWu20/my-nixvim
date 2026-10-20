{ lib, ... }:
let
  # No lazyLoad trigger on purpose: in this nixvim pin the pack
  # dir links telescope into start/ regardless, so its own
  # :Telescope command beats the lz-n trigger and the generated
  # setup after-hook never ran. Eager loading moves the setup
  # call into the startup lua config. Revert by re-adding
  # `lazyLoad.settings.cmd = "Telescope";`.
  nlua = lib.nixvim.mkRaw;
  # Picker action: yank the highlighted entry's filepath to the
  # " register (system clipboard via unnamedplus) and, inside
  # tmux, into the tmux paste buffer for `prefix ]`.
  # `filename` is set on grep entries; `value` holds the path on
  # file-picker entries.
  yankPath = nlua ''
    function(prompt_bufnr)
      local state = require("telescope.actions.state")
      local entry = state.get_selected_entry()
      if not entry then
        local picker = state.get_current_picker(prompt_bufnr)
        entry = picker and picker.get_selection(picker)
      end
      if entry then
        local path = entry.filename or entry.value
        if type(path) == "string" and path ~= "" then
          vim.fn.setreg('"', path)
          if vim.env.TMUX ~= nil and vim.fn.executable("tmux") == 1 then
            vim.fn.system({ "tmux", "load-buffer", "-" }, path)
          end
          vim.notify("Yanked: " .. path)
        end
      end
    end
  '';
in
{
  plugins.telescope = {
    enable = true;
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
    # Yank the filepath of the highlighted entry to the system clipboard.
    # `<C-y>` in both prompt modes: insert (the default, initial_mode =
    # "insert" above) and normal (entered with `<Esc>`; the picker's
    # normal-mode `<Esc>` then closes). `<C-y>` is free in this telescope
    # version: its default i/n mappings do not bind it. The map sits in
    # `defaults.mappings`, so it reaches every picker.
    settings.defaults.mappings = {
      i = {
        "<C-y>" = yankPath;
      };
      n = {
        "<C-y>" = yankPath;
      };
    };
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
  # UI (nvimdots category: ui.lua)
  # ------------------------------------------------------------------
}
