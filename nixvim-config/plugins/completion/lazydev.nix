{
  plugins.lazydev = {
    enable = true;
    lazyLoad.settings.ft = "lua";
    settings.library = [
      "lazy.nvim"
      {
        path = "luvit-meta/library";
        words = [ "vim%.uv" ];
      }
    ];
  };

  # None-ls formatters. Each source auto-adds its nixpkgs binary to PATH.
}
