{
  plugins.bufferline = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufAdd"
      "BufNewFile"
    ];
    settings.options.always_show_bufferline = true;
    settings.options.close_command = "BufDel! %d";
    settings.options.right_mouse_command = "BufDel! %d";
    settings.options.diagnostics = "nvim_lsp";
  };
  # Statusline. The nixvim lualine defaults (mode/branch/filename/encoding/
  # progress/location) have no LSP client-name component, so the active
  # server is invisible. The old nvimdots statusline
  # (lua/modules/configs/ui/lualine.lua) rendered a custom `components.lsp`
  # that listed the attached server names next to the diagnostics count, so
  # that indicator is ported into `lualine_c` here: `filename` keeps the
  # default section-c entry, `diagnostics` restores the old E/W/I/H counts,
  # and the raw component lists the active LSP server name(s).
}
