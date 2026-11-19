{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
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
        };
      }
    );
    default = { };
    description = "NixOS configurations using the unstable nixpkgs channel.";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name:
    { module, homeUsers }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        module
      ]
      ++ lib.optional (homeUsers != { }) {
        home-manager.users = homeUsers;
      };
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.nixos;
}
