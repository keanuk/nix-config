{
  config,
  inputs,
  lib,
  ...
}:
{
  options.nixpkgs.baseOverlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    description = ''
      Shared overlay list applied to every nixpkgs instantiation (NixOS,
      nix-darwin, and standalone home-manager) so call sites cannot drift apart.
    '';
  };

  config = {
    flake.overlays = {
      additions = final: _prev: import ./_pkgs.nix { pkgs = final; };

      unstable-packages = final: _prev: {
        unstable = import inputs.nixpkgs {
          inherit (final.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
            allowImportFromDerivation = true;
            permittedInsecurePackages = final.config.permittedInsecurePackages or [ ];
          };
        };
      };

      stable-packages = final: _prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (final.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
            allowImportFromDerivation = true;
            permittedInsecurePackages = final.config.permittedInsecurePackages or [ ];
          };
        };
      };

      default = lib.composeManyExtensions config.nixpkgs.baseOverlays;
    };

    # Keep hermes-agent.overlays.default here (lazy until pkgs.hermes-agent is
    # referenced on ursa) so both nixosConfigurations.ursa (useGlobalPkgs = true)
    # and standalone homeConfigurations."keanu@ursa" receive it cleanly.
    # Inactive DE overlays (e.g. hyprland) live in their own role modules.
    nixpkgs.baseOverlays =
      with config.flake.overlays;
      [
        unstable-packages
        stable-packages
        additions
      ]
      ++ [
        inputs.hermes-agent.overlays.default
      ];
  };
}
