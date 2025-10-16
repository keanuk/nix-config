{ outputs, ... }:
{
  imports = [
    ./homebrew.nix
    ./packages.nix

    ../services/comin.nix

    ../../desktop/fonts.nix
  ];

  # Disabled for Determinate Nix
  nix.enable = false;

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.stable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };
}
