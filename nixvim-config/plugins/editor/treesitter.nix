{
    # Treesitter: install the full Nix grammar set (superset of the old
    # ensure_installed list). highlight + indent via native APIs.
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
  };
}
