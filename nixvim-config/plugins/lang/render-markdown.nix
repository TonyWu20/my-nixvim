{
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
  # Tool (nvimdots category: tool.lua)
  # ------------------------------------------------------------------
}
