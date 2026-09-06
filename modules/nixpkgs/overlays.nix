{ inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ./_pkgs.nix { pkgs = final; };

    unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs {
        inherit (final.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
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
}
