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

        data = {
          usageMessage = ''
            Available nix-presentations flake commands:

              nix run .#usage

              nix run .#presentationLauncher
          '';

          configPresenterm = ./.presenterm.yaml;
        };

        scripts = {
          showUsage = pkgs.writeShellApplication {
            name = "usage";
            text = ''
              printf "%s" "${data.usageMessage}"
              printf "\n"
            '';
          };

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
              declare answer=""

              while [[ ''${answer} != quit ]]; do

                printf "Discovering presentations...\n"
                printf "\n"

                files=( ./presentations/*/presentation.md )

                for f in "''${files[@]}"; do
                  name="$(dirname "''${f}")"
                  name="''${name##*/}"
                  presentations["''${name}"]="''${f}"
                done

                answer="$(gum choose --header="Please select a presentation" --select-if-one --ordered "''${!presentations[@]}" reload quit)"
                printf "\n"

                [[ ''${answer} == quit ]] && break
                [[ ''${answer} == reload ]] && continue

                presenterm --config-file "${data.configPresenterm}" "''${presentations[''${answer}]}"
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
          default = self.apps.${system}.usage;

          usage = {
            type = "app";
            program = "${pkgs.lib.getExe scripts.showUsage}";
          };

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
