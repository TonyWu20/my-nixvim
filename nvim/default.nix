# home-manager module: ships the my-nix-nvim config into ~/.config/nvim and
# wires up the neovim program + build tooling.
#
# Options (programs.neovim.myNvim):
#   enable          activate the config
#   setBuildEnv     export CPATH/LD_LIBRARY_PATH so mason/treesitter can build
#   withBuildTools  add gcc, pkg-config, gnumake, ninja, cargo to the wrapper
{ pkgs, lib, config, ... }:
let
  cfg = config.programs.neovim.myNvim;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  # Build environment for mason / treesitter source builds.
  buildDeps = pkgs.buildEnv {
    name = "neovim-build-deps";
    paths = with pkgs; [
      glibc
      openssl
      zlib
      xz
      curl
      libsodium
      libssh
      libxml2
      pkg-config
      (pkgs.stdenv.cc.cc)
      (pkgs.stdenv.cc.cc.lib)
    ];
    extraOutputsToInstall = [ "dev" ];
    pathsToLink = [ "/lib" "/include" ];
    ignoreCollisions = true;
  };

  # Wrapper args are only emitted when setBuildEnv is on.
  buildEnvArgs = if cfg.setBuildEnv then [
    "--suffix" "CPATH" ":" "${buildDeps}/include"
    "--suffix" "CPLUS_INCLUDE_PATH" ":" "${buildDeps}/include/c++/v1"
    "--suffix" "LD_LIBRARY_PATH" ":" "${buildDeps}/lib"
    "--suffix" "LIBRARY_PATH" ":" "${buildDeps}/lib"
    "--suffix" "NIX_LD_LIBRARY_PATH" ":" "${buildDeps}/lib"
    "--suffix" "PKG_CONFIG_PATH" ":" "${buildDeps}/include/pkgconfig"
  ] else [ ];
in
{
  options = {
    programs.neovim.myNvim = {
      enable = mkEnableOption "the my-nix-nvim minimal neovim config";
      setBuildEnv = mkEnableOption "export CPATH/LD_LIBRARY_PATH for mason & treesitter builds";
      withBuildTools = mkEnableOption "add gcc, pkg-config, gnumake, ninja, cargo to the neovim wrapper";
    };
  };

  config = mkIf cfg.enable {
    # Ship the config into the XDG config dir.
    xdg.configFile = {
      "nvim/init.lua".source = ../init.lua;
      "nvim/lua".source = ../lua;
    };

    # ripgrep is required by the telescope vimgrep args and the rg source.
    home.packages = [ pkgs.ripgrep ];

    programs.neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages =
        [ pkgs.tree-sitter ]
        ++ optionals cfg.withBuildTools [
          pkgs.gcc
          pkgs.pkg-config
          pkgs.gnumake
          pkgs.ninja
          pkgs.cargo
        ];
      extraWrapperArgs = buildEnvArgs;
    };
  };
}
