{ config, inputs, ... }:
let
  baseOverlays = (builtins.attrValues config.flake.overlays) ++ [
    inputs.nix-openclaw.overlays.default
  ];
in
{
  flake.modules.nixos.base = {
    nixpkgs = {
      overlays = baseOverlays;
      config = {
        allowUnfree = true;
        allowImportFromDerivation = true;
      };
    };
  };

  flake.modules.darwin.base = {
    nixpkgs = {
      overlays = baseOverlays;
      config = {
        allowUnfree = true;
        allowImportFromDerivation = true;
      };
    };
  };
}
