{ config, inputs, ... }:
let
  baseOverlays =
    with config.flake.overlays;
    [
      unstable-packages
      stable-packages
      additions
      modifications
    ]
    ++ [ inputs.nix-openclaw.overlays.default ]
    ++ [
      config.flake.overlays.pnpm-slim-fix
      config.flake.overlays.openclaw-node24-fix
    ];
in
{
  flake.modules.darwin.base = _: {
    # Disabled for Determinate Nix
    nix.enable = false;

    nixpkgs = {
      overlays = baseOverlays;
      config = {
        allowUnfree = true;
      };
    };
  };
}
