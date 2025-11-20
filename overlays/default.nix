{inputs, ...}: let
  fixes = [
    ./fixes/macos-ruby.nix
  ];

  # Combine all fix overlays into a single overlay
  combinedFixes = final: prev:
    builtins.foldl'
    (acc: overlay: acc // (overlay final prev))
    {}
    (map import fixes);
in {
  # Custom packages defined in ../pkgs
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # Package modifications and temporary fixes
  modifications = combinedFixes;

  # Access to nixpkgs unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # Access to nixpkgs stable
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
