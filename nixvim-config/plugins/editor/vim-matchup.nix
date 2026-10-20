{
  plugins.vim-matchup = {
    enable = true;
    # Port of the old vimscript-plugin globals (matchup_*). The plugin module
    # prefixes these settings into `globals.matchup_*` automatically.
    settings.transmute_enabled = 1;
    settings.surround_enabled = 1;
    settings.matchparen_offscreen = {
      method = "popup";
    };
  };
}
