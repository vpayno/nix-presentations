# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
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
