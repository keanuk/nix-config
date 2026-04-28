{
  lib,
  config,
  inputs,
  ...
}:
{
  config.flake.deploy.nodes = lib.mapAttrs (name: cfg: {
    inherit (cfg.deploy) hostname;
    profiles.system = {
      user = "root";
      sshUser = cfg.deploy.sshUser or "keanu";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.${name};
    };
  }) (lib.filterAttrs (_: cfg: cfg.isVps) config.configurations.nixos-stable);

  config.perSystem =
    { system, ... }:
    {
      checks = inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy;
    };
}
