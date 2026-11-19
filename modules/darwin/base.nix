{ config, ... }:
{
  flake.modules.darwin.base = _: {
    # Disabled for Determinate Nix
    nix.enable = false;

    nixpkgs = {
      overlays = config.nixpkgs.baseOverlays;
      config = {
        allowUnfree = true;
        allowImportFromDerivation = true;
      };
    };
  };
}
