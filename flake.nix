{
  description = "Provide a home-manager module for the my-nix-nvim minimal neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, ... }:
    {
      # The home-manager module, imported as `my-nvim.homeManagerModules.default`.
      homeManagerModules.default = ./nvim;
    };
}
