{
    # tpope/vim-sleuth: auto-detects indent/tab options per filetype. Port of
    # the old editor.lua spec: lazy on BufNewFile/BufReadPost/BufFilePost, no
    # settings table. The module defaults (heuristics on) already match.
  plugins.sleuth = {
    enable = true;
    lazyLoad.settings.event = [
      "BufNewFile"
      "BufReadPost"
      "BufFilePost"
    ];
  };

  # Treesitter: install the full Nix grammar set (superset of the old
  # ensure_installed list). highlight + indent via native APIs.
}
