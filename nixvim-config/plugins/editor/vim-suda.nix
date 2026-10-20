{
  plugins.vim-suda = {
    enable = true;
    lazyLoad.settings.cmd = [
      "SudaRead"
      "SudaWrite"
    ];
  };

  # tpope/vim-sleuth: auto-detects indent/tab options per filetype. Port of
  # the old editor.lua spec: lazy on BufNewFile/BufReadPost/BufFilePost, no
  # settings table. The module defaults (heuristics on) already match.
}
