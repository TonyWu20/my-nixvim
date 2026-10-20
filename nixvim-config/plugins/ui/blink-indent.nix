{
  plugins.blink-indent = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    settings = {
      mappings = {
        # which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
        border = "both";
        # set to "" to disable
        # textobjects (e.g. `y2ii` to yank current and outer scope)
        object_scope = "ii";
        object_scope_with_border = "ai";
        # motions
        goto_top = "[i";
        goto_bottom = "]i";
      };
      scope = {
        enabled = true;
        indent_at_cursor = true;
        underline.enabled = true;
      };
    };
  };
}
