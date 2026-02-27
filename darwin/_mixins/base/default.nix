{ inputs, outputs, ... }:
{
  imports = [
    ./homebrew.nix
    ./packages.nix

    # TODO: Figure out how to make it work with determinate nix
    # ../services/comin.nix

    ../desktop/fonts.nix

    ../fixes
  ];

  # Disabled for Determinate Nix
  nix.enable = false;

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.stable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nix-openclaw.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
