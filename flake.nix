{
  description = "Neovim configured declaratively with Nixvim, delivered as a home-manager module.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Nixvim is tested against its OWN pinned nixpkgs revision, so do NOT
    # `follows` nixpkgs here. It builds the nvim wrapper on its pin.
    nixvim.url = "github:nix-community/nixvim";

    # Kept as an input so the consumer's `inputs.home-manager.follows` stays
    # valid; the home-manager module this flake produces is merged into the
    # consumer's home-manager evaluation.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixvim, home-manager, ... }:

    let
      # A Nixvim module (top-level nixvim options): options, keymaps, plugins,
      # LSP servers, formatters, and runtime packages. Works both when merged
      # into a home-manager config (via `programs.nixvim.imports`) and when
      # built standalone (via `nixvim.lib.evalNixvim`).
      nixvimConfig = ./nixvim-config;

      # The home-manager entrypoint. The consumer imports this module; it turns
      # on `programs.nixvim` and feeds it our declarative config.
      homeModule =
        { config, lib, ... }:
        {
          imports = [ nixvim.homeModules.nixvim ];

          programs.nixvim = {
            enable = true;
            defaultEditor = true;
            # Our declarative module.
            imports = [ nixvimConfig ];
          };
        };
    in
    {
      # Home-manager entrypoints (nixvim exposes both spellings).
      homeModules.default = homeModule;
      homeManagerModules.default = homeModule;

      # A buildable Nixvim package so the config can be validated with
      # `nix build` / `nix flake check` without a full home-manager eval.
      #
      # NOTE: the `evalNixvim` call MUST be parenthesized before accessing
      # `.config`: without the parens Nix binds `.config` onto the argument
      # attrset instead of the call's result ("attribute 'config' missing").
      packages =
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ]
        (
          system:
          {
            default =
              (nixvim.lib.evalNixvim {
                inherit system;
                modules = [ nixvimConfig ];
              })
              .config.build.package;
          }
        );
    };
}
