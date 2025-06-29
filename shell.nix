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
    moreutils
    presenterm
    runme
  ];

  inputsFrom = [
  ];

  GREETING = "Welcome to nix-presentations' devShell!";

  shellHook = ''
    ${pkgs.lib.getExe pkgs.cowsay} "''${GREETING}"
  '';
}
