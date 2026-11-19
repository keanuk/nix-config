{
  lib,
  config,
  inputs,
  ...
}:
{
  config.flake.deploy.nodes = lib.mapAttrs (
    name: cfg:
    let
      nixosCfg = config.flake.nixosConfigurations.${name};
      inherit (nixosCfg.pkgs.stdenv.hostPlatform) system;
    in
    {
      inherit (cfg.deploy) hostname;
      profiles.system = {
        user = "root";
        sshUser = cfg.deploy.sshUser or "keanu";
        path = inputs.deploy-rs.lib.${system}.activate.nixos nixosCfg;
      };
    }
  ) (lib.filterAttrs (_: cfg: cfg.isVps) config.configurations.nixos-stable);

  config.perSystem =
    { system, ... }:
    {
      checks = inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy;
    };
}
