{
    # None-ls formatters. Each source auto-adds its nixpkgs binary to PATH.
  plugins.none-ls = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    sources = {
      formatting.clang_format = {
        enable = true;
        settings.filetypes = [
          "c"
          "cpp"
          "objc"
          "objcpp"
          "cs"
          "cuda"
          "proto"
        ];
      };
      formatting.prettier = {
        enable = true;
        settings.filetypes = [
          "vue"
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
          "yaml"
          "html"
          "css"
          "scss"
          "sh"
          "markdown"
        ];
      };
      formatting.shfmt.enable = true;
      formatting.stylua.enable = true;
      diagnostics.vint.enable = true;
    };
  };
}
