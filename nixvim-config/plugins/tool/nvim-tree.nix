{
  plugins.nvim-tree = {
    enable = true;
    lazyLoad.settings.cmd = [
      "NvimTreeToggle"
      "NvimTreeOpen"
      "NvimTreeFindFile"
      "NvimTreeFindFileToggle"
      "NvimTreeRefresh"
    ];
    # Port of the NvimTreeAutoClose autocmd from the old core/event.lua:
    # quit when the tree is the only remaining window in the tab.
    autoClose = true;
  };
}
