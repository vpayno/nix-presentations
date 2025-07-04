# shell.nix
{
  pkgs ? import <nixpkgs> {
    overlays = (import ./overlays.nix { }).overlays;
  },
  ...
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    bashInteractive
    coreutils-full
    git
    glow
    marp-cli
    mdp
    mermaid-cli
    moreutils
    presenterm
    python313Packages.weasyprint
    runme
  ];

  inputsFrom = [
  ];

  GREETING = "Welcome to nix-presentations' devShell!";

  shellHook = ''
    ${pkgs.lib.getExe pkgs.cowsay} "''${GREETING}"
  '';
}
