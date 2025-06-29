# overlays.nix
{
  ...
}:
let
  patches = [
    ./patches/themes-gruvbox-midnight.patch
  ];

  overlayPresenterm = (
    self: super: {
      presenterm = super.presenterm.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches or [ ] ++ patches;
      });
    }
  );
in
{
  overlays = [
    overlayPresenterm
  ];
}
