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
    description = "NixOS configurations using the stable (25.11) nixpkgs channel — used for VPS hosts.";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name: cfg:
    inputs.nixpkgs-stable.lib.nixosSystem {
      modules = [ cfg.module ];
      specialArgs = { inherit inputs; };
    }
  ) config.configurations.nixos-stable;
}
