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
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
    default = { };
    description = "nix-darwin configurations.";
  };

  config.flake.darwinConfigurations = lib.mapAttrs (
    _name:
    { module }:
    inputs.darwin.lib.darwinSystem {
      modules = [ module ];
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.darwin;
}
