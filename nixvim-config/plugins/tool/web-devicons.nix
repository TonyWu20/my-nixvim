{
  plugins.web-devicons.enable = true;
  # DECISION (2026-10): this plugin used to lazy-load on its `cmd`
  # trigger (`lazyLoad.settings.cmd = "Telescope"`). In this nixvim pin,
  # the built pack dir places telescope.nvim in `start/` anyway (the
  # plugin files load at startup), so its own `:Telescope` command
  # outlives the lz-n trigger registration and the generated
  # `telescope.setup()` after-hook never ran on the normal
  # `<leader>ff` / `:Telescope` flows. That left every setting below
  # (vimgrep args, layout, extensions, and the `<C-y>` yank map) as
  # dead code. Making the plugin eager moves the generated setup
  # (setup call + `load_extension` loop) into the startup lua config,
  # so the settings apply before any picker opens. The plugin files
  # were already loading eagerly, so this adds no startup work.
  # Revert by restoring `lazyLoad.settings.cmd = "Telescope";`.
}
