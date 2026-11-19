{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.darwin = lib.mkOption {
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
    description = "nix-darwin configurations.";
  };

  config.flake.darwinConfigurations = lib.mapAttrs (
    _name:
    { module, homeUsers }:
    inputs.darwin.lib.darwinSystem {
      modules = [
        module
      ]
      ++ lib.optional (homeUsers != { }) {
        home-manager.users = homeUsers;
      };
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.darwin;
}
