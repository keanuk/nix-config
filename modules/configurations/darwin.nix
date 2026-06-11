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
          darwinInput = lib.mkOption {
            type = lib.types.str;
            default = "darwin";
            description = "The flake input representing nix-darwin to use.";
          };
        };
      }
    );
    default = { };
    description = "nix-darwin configurations.";
  };

  config.flake.darwinConfigurations = lib.mapAttrs (
    _name:
    { module, darwinInput }:
    let
      darwinLib = inputs.${darwinInput} or inputs.darwin;
    in
    darwinLib.lib.darwinSystem {
      modules = [ module ];
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.darwin;
}
