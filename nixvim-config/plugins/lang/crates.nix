{
  plugins.crates = {
    enable = true;

    # Optional settings block configured for inline version hints
    settings = {
      smart_insert = true;
      insert_closing_quote = true;

      # Configure the layout of the virtual text inline hints
      text = {
        searching = "  🔍 searching...";
        version = "  ⭐ %s"; # Shows the latest compatible version
        prerelease = "  🚧 %s";
        yanked = "  ❌ %s yanked";
      };

      popup = {
        autofocus = true;
        border = "rounded";
      };
    };
  };
}
