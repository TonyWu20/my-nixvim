{
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
}
