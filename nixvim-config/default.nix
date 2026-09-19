# Nixvim module: the declarative replacement for the old hand-rolled
# init.lua + lua/ tree. Imported into a home-manager config via
# `programs.nixvim.imports`, or built standalone via `nixvim.lib.evalNixvim`.
{ config, lib, pkgs, ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins.nix
    ./extra-lua.nix
  ];

  # Node-based servers/formatters (prettier, ts_ls family) need a node provider.
  withNodeJs = true;

  # Clipboard: use the system clipboard (register `unnamedplus`). Declared via
  # nixvim's `clipboard` module option rather than raw `options.clipboard`
  # (the raw option does not accept a nested `register` form).
  clipboard.register = "unnamedplus";

  # A few community plugins in the set are license-less or explicitly unfree
  # in nixpkgs (e.g. faster.nvim ships no license field). Permit unfree
  # packages for this editor's build via nixvim's pinned nixpkgs.
  # (We do NOT set `nixpkgs.pkgs` ourselves, so `nixpkgs.config` is allowed
  # by the nixvim assertion.)
  nixpkgs.config.allowUnfree = true;

  # Active colorscheme (user preference: catppuccin-macchiato).
  colorscheme = "catppuccin-macchiato";

  # Runtime packages this config relies on. `rg` backs the `grepprg` option,
  # the telescope vimgrep args, and the blink-ripgrep completion source.
  extraPackages = [ pkgs.ripgrep ];

  # Global variables (vim.g.*) that no nixvim plugin module declares: the
  # leader keys and the suda prompt. The vim-matchup globals are NOT set here.
  # The vim-matchup plugin module exposes them as typed settings and auto
  # prefixes them into `globals.matchup_*`, so they are configured on
  # `plugins.vim-matchup.settings` (see plugins.nix). Setting the freeform
  # `globals.matchup_*` here collides with those typed options.
  globals = {
    mapleader = " ";
    mapleader2 = "-";
    "suda#prompt" = "Enter administrator password: ";
  };
}
