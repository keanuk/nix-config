{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nixos-stable = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
          homeUsers = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.deferredModule;
            default = { };
            description = "Home Manager user modules wired into both home-manager.users and standalone homeConfigurations.";
          };
          isVps = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this host is a VPS deployed via deploy-rs.";
          };
          deploy = lib.mkOption {
            type = lib.types.attrs;
            default = { };
            description = "deploy-rs node attributes (hostname, sshUser).";
          };
        };
      }
    );
    default = { };
    description = "NixOS configurations using the stable (26.05) nixpkgs channel (VPS hosts and ursa).";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name: cfg:
    inputs.nixpkgs-stable.lib.nixosSystem {
      modules = [
        cfg.module
      ]
      ++ lib.optional (cfg.homeUsers != { }) {
        home-manager.users = cfg.homeUsers;
      };
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.nixos-stable;
}
