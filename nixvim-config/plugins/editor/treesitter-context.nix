{
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
}
