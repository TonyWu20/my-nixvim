{
  plugins.scrollview = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
  };
  # smart-splits.nvim: directional split navigation (left/right/up/down
  # instead of wider/narrower/taller/shorter). Restores the old
  # keymap/ui.lua maps:
  #   <C-h/j/k/l> focus a split        (:SmartCursorMove*)
  #   <A-h/j/k/l> resize a split by 3  (:SmartResize*)
  #   <leader>W{h,j,k,l} swap windows  (:SmartSwap*)
  # The old spec was lazy on CursorHold/CursorHoldI. The same events are
  # kept. The `cmd` triggers add the 12 `:Smart*` commands so the keymaps
  # in keymaps.nix work on first press instead of waiting for the first
  # CursorHold.
  #
  # DECISION (2026-10): this plugin was `[ ]` in plugin-selection.md and was
  # not in the initial nixvim port. It is added now because the user expects
  # the old `<C-h/j/k/l>` split-focus keys to work. If this decision is
  # reversed, remove this block, the 12 smart-splits keymaps in keymaps.nix,
  # and the `<leader>W` which-key group below.
}
