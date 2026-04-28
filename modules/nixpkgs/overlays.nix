{ inputs, ... }:
let
  fixes = [
    ./_fixes/openldap.nix
  ];

  combinedFixes =
    final: prev: builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } (map import fixes);
in
{
  flake.overlays = {
    additions = final: _prev: import ./_pkgs.nix { pkgs = final; };

    modifications = combinedFixes;

    unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs {
        inherit (final.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
        };
        overlays = [ combinedFixes ];
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
}
