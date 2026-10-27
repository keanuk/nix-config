{ config, inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ./_pkgs.nix { pkgs = final; };

    unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs {
        inherit (final.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = final.config.permittedInsecurePackages or [ ];
        };
      };
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
        };
      };
    };
  };

  # The overlay set applied to every nixpkgs instantiation (NixOS, nix-darwin,
  # and standalone home-manager). Defined once here so the call sites in
  # nixos/nix-settings.nix, darwin/base.nix, and configurations/home-manager.nix
  # cannot drift apart.
  flake.baseOverlays =
    with config.flake.overlays;
    [
      unstable-packages
      stable-packages
      additions
    ]
    ++ [
      inputs.hermes-agent.overlays.default
      inputs.hyprland.overlays.hyprland-packages
      inputs.hyprland.overlays.hyprland-extras
    ];
}
