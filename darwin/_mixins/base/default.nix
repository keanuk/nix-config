{outputs, ...}: {
  imports = [
    ./homebrew.nix
    ./packages.nix

    # TODO: Figure out how to make it work with determinate nix
    # ../services/comin.nix

    ../desktop/fonts.nix

    ../fixes/default.nix
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
