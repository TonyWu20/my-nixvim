{
  plugins.ts-autotag = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    # No settings: the plugin's defaults (enable_close = true,
    # enable_rename = true, enable_close_on_slash = false) already match
    # our requirements. Use `settings.opts.*` if we ever need overrides.
  };
}
