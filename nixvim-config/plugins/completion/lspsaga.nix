{
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
      symbol_in_winbar.enable = true;
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
  # Editor (nvimdots category: editor.lua)
  # ------------------------------------------------------------------
}
