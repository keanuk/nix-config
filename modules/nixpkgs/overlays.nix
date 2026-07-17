{ inputs, ... }:
let
  fixes = [
    ./_fixes/handbrake.nix
    ./_fixes/patool.nix
  ];

  combinedFixes =
    final: prev: builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } (map import fixes);
in
{
  flake.overlays = {
    additions = final: _prev: import ./_pkgs.nix { pkgs = final; };

    modifications = combinedFixes;

    pnpm-slim-fix =
      final: prev:
      (prev.lib.optionalAttrs (prev ? pnpm_11) {
        pnpm_11 = prev.pnpm_11.overrideAttrs (old: {
          passthru = (old.passthru or { }) // {
            inherit (final) nodejs-slim;
          };
        });
      })
      // (prev.lib.optionalAttrs (prev ? pnpm) {
        pnpm = prev.pnpm.overrideAttrs (old: {
          passthru = (old.passthru or { }) // {
            inherit (final) nodejs-slim;
          };
        });
      });

    # Must be applied after inputs.nix-openclaw.overlays.default.
    openclaw-node24-fix = import ./_fixes/openclaw-nodejs.nix;

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
