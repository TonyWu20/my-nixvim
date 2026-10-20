{
  plugins.autoclose = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    settings.keys = {
      " " = {
        escape = false;
        close = true;
        pair = "()";
      };
      "[" = {
        escape = false;
        close = true;
        pair = "[]";
      };
      "{" = {
        escape = false;
        close = true;
        pair = "{}";
      };
      "<" = {
        escape = true;
        close = true;
        pair = "<>";
        enabled_filetypes = [ "rust" ];
      };
      ">" = {
        escape = true;
        close = false;
        pair = "<>";
      };
      ")" = {
        escape = true;
        close = false;
        pair = "()";
      };
      "]" = {
        escape = true;
        close = false;
        pair = "[]";
      };
      "}" = {
        escape = true;
        close = false;
        pair = "{}";
      };
      "\"" = {
        escape = true;
        close = true;
        pair = "\"\"";
      };
      "`" = {
        escape = true;
        close = true;
        pair = "``";
      };
      "'" = {
        escape = true;
        close = true;
        pair = "''";
        disabled_filetypes = [ "rust" ];
      };
    };
    settings.options.disabled_filetypes = [
      "alpha"
      "checkhealth"
      "diff"
      "help"
      "log"
      "NvimTree"
      "qf"
      "TelescopePrompt"
    ];
  };
}
