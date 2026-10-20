{
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
}
