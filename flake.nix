# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    systems.url = "github:vpayno/nix-systems-default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    treefmt-conf = {
      url = "github:vpayno/nix-treefmt-conf";
      inputs.nixpkgs.follows = "nixpkgs";
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

        scripts = {
          presentationLauncher = pkgs.writeShellApplication {
            name = "presentation-launcher";
            runtimeInputs = with pkgs; [
              coreutils-full
              gnugrep
              gnused
              gum
              presenterm
            ];
            text = ''
              declare -a files
              declare f
              declare -A presentations # [name]=path
              declare name
              declare answer

              files=( ./presentations/*/presentation.md )

              for f in "''${files[@]}"; do
                name="$(dirname "''${f}")"
                name="''${name##*/}"
                presentations["''${name}"]="''${f}"
              done

              while answer="$(gum choose --header="Please select a presentation" --select-if-one --ordered "''${!presentations[@]}" quit)"; do
                printf "\n"

                [[ ''${answer} == quit ]] && break

                presenterm "''${presentations[''${answer}]}"
              done
            '';
          };
        };
      in
      {
        formatter = inputs.treefmt-conf.formatter.${system};

        packages = {
          inherit (pkgs) presenterm;
        };

        apps = {
          presentationLauncher = {
            type = "app";
            program = "${pkgs.lib.getExe scripts.presentationLauncher}";
          };
        };

        devShells = {
          default = pkgs.callPackage ./shell.nix {
            inherit pkgs;
          };
        };
      }
    );
}
