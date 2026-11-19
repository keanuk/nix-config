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
        type = lib.types.enum config.systems;
        description = "System architecture for this home-manager configuration.";
      };
      module = lib.mkOption {
        type = lib.types.deferredModule;
      };
    };
  };

  inherit (config.nixpkgs) baseOverlays;

  mkHostHomes =
    hostConfigs: osFlakeOutputs:
    lib.concatMapAttrs (
      host: hostCfg:
      lib.mapAttrs' (
        user: userModule:
        lib.nameValuePair "${user}@${host}" {
          system = osFlakeOutputs.${host}.pkgs.stdenv.hostPlatform.system;
          module = userModule;
        }
      ) hostCfg.homeUsers
    ) hostConfigs;

  mkHomeConfig =
    nixpkgsInput: hmInput: _name: cfg:
    let
      pkgs = import nixpkgsInput {
        inherit (cfg) system;
        overlays = baseOverlays;
        config = {
          allowUnfree = true;
          allowImportFromDerivation = true;
        };
      };
    in
    hmInput.lib.homeManagerConfiguration {
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
      description = "Standalone home-manager configurations using the stable (26.05) channel.";
    };
  };

  config = {
    configurations = {
      homeManager = lib.mkMerge [
        (mkHostHomes config.configurations.nixos config.flake.nixosConfigurations)
        (mkHostHomes config.configurations.darwin config.flake.darwinConfigurations)
      ];
      homeManager-stable = mkHostHomes config.configurations.nixos-stable config.flake.nixosConfigurations;
    };

    flake.homeConfigurations =
      let
        unstable = lib.mapAttrs (mkHomeConfig inputs.nixpkgs inputs.home-manager) config.configurations.homeManager;
        stable = lib.mapAttrs (mkHomeConfig inputs.nixpkgs-stable inputs.home-manager-stable) config.configurations.homeManager-stable;
        overlap = lib.attrNames (lib.intersectAttrs unstable stable);
      in
      assert lib.assertMsg (overlap == [ ])
        "Duplicate homeConfigurations keys in both homeManager and homeManager-stable: ${lib.concatStringsSep ", " overlap}";
      unstable // stable;
  };
}
