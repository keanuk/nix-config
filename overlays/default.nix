{inputs, ...}: let
  # Import all fixes from the fixes directory
  # Comment out any fixes that are no longer needed
  fixes = [
    ./fixes/batgrep.nix
    ./fixes/mercantile.nix
    ./fixes/qt6-packages.nix
    ./fixes/macos-ruby.nix
  ];

  # Combine all fix overlays into a single overlay
  combinedFixes = final: prev:
    builtins.foldl'
    (acc: overlay: acc // (overlay final prev))
    {}
    (map (path: import path) fixes);
in {
  # Custom packages defined in ../pkgs
  additions = final: prev: import ../pkgs {pkgs = final;};

  # Package modifications and temporary fixes
  modifications = combinedFixes;

  # Access to nixpkgs unstable
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # Access to nixpkgs stable
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
