{
  plugins.mini-cursorword = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
    settings.delay = 200;
  };
}
