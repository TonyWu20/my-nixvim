{
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
}
