{
  lib,
  config,
  inputs,
  ...
}:
let
  homeConfigSubmodule = lib.types.submodule {
    options = {
      system = lib.mkOption {
        type = lib.types.str;
        description = "System architecture for this home-manager configuration.";
      };
      module = lib.mkOption {
        type = lib.types.deferredModule;
      };
    };
  };

  baseOverlays =
    with config.flake.overlays;
    [
      unstable-packages
      stable-packages
      additions
      modifications
    ]
    ++ [ inputs.nix-openclaw.overlays.default ];

  mkUnstable =
    _name: cfg:
    let
      pkgs = import inputs.nixpkgs {
        inherit (cfg) system;
        overlays = baseOverlays;
        config = {
          allowUnfree = true;
          allowImportFromDerivation = true;
        };
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ cfg.module ];
      extraSpecialArgs = { inherit inputs; };
    };

  mkStable =
    _name: cfg:
    let
      pkgs = import inputs.nixpkgs-stable {
        inherit (cfg) system;
        overlays = baseOverlays;
        config = {
          allowUnfree = true;
          allowImportFromDerivation = true;
        };
      };
    in
    inputs.home-manager-stable.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ cfg.module ];
      extraSpecialArgs = { inherit inputs; };
    };
in
{
  options.configurations = {
    homeManager = lib.mkOption {
      type = lib.types.lazyAttrsOf homeConfigSubmodule;
      default = { };
      description = "Standalone home-manager configurations using the unstable channel.";
    };
    homeManager-stable = lib.mkOption {
      type = lib.types.lazyAttrsOf homeConfigSubmodule;
      default = { };
      description = "Standalone home-manager configurations using the stable (25.11) channel.";
    };
  };

  config.flake.homeConfigurations =
    (lib.mapAttrs mkUnstable config.configurations.homeManager)
    // (lib.mapAttrs mkStable config.configurations.homeManager-stable);
}
