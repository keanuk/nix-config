{ config, inputs, ... }:
let
  baseOverlays = with config.flake.overlays; [
    unstable-packages
    stable-packages
    additions
    modifications
  ]
  ++ [ inputs.nix-openclaw.overlays.default ];
in
{
  flake.modules.darwin.base = _: {
    imports = with config.flake.modules.darwin; [
      packages

      # TODO: Figure out how to make it work with determinate nix
      # svc-comin

      desktop-fonts

      fixes
    ];

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
