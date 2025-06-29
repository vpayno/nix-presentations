# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    systems.url = "github:vpayno/nix-systems-default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        myOverlays = import ./overlays.nix { };

        pkgs = import nixpkgs {
          inherit system;
          inherit (myOverlays) overlays;
        };
      in
      {
        packages = {
          inherit (pkgs) presenterm;
        };

        devShells = {
          default = pkgs.callPackage ./shell.nix {
            inherit pkgs;
          };
        };
      }
    );
}
