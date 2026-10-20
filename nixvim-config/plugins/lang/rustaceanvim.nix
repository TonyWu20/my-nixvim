{
  plugins.rustaceanvim = {
    enable = true;
    lazyLoad.settings.ft = "rust";
    settings.dap = {
      adapter = false;
      configuration = false;
      autoload_configurations = false;
    };
    settings.server.standalone = true;
    settings.server.default_settings."rust-analyzer" = {
      checkOnSave = true;
      procMacro = {
        enable = true;
      };
      completion = {
        autoimport = true;
      };
      files = {
        excludeDirs = [ ".direnv" ];
      };
    };
  };
}
