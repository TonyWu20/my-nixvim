{
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
}
