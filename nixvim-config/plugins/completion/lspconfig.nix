{
  plugins.lspconfig.enable = true; # nvim-lspconfig registry (server defaults)

  # nvimdev/lspsaga: LSP UI (code actions, diagnostic flythrough, hover,
  # rename, call hierarchy). Port of the old lua/modules/configs/completion/
  # lspsaga.lua, lazy-loaded on LspAttach as before.
  #
  # Functional settings are ported verbatim. The icon-glyph fields that
  # nvimdots pulled from its modules.utils.icons table (ui.kind, ui.imp_sign,
  # ui.expand, ui.collapse, ui.code_action, ui.actionfix,
  # symbol_in_winbar.separator) are dropped: web-devicons (enabled above)
  # supplies the lspkind glyphs lspsaga falls back to.
  #
  # Nixvim warns that `implement` wants `symbol_in_winbar` enabled. The old
  # config deliberately ran implement on with the winbar breadcrumbs off, so
  # the port keeps that combination and accepts the build warning.
  #
  # hover.open_cmd uses the old core.settings external_browser default.
}
