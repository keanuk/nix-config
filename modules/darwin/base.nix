{ config, ... }:
{
  flake.modules.darwin.base = _: {
    # Disabled for Determinate Nix
    nix.enable = false;

    nixpkgs = {
      overlays = config.flake.baseOverlays;
      config = {
        allowUnfree = true;
      };
    };
  };
}
