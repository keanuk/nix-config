{ lib, config, ... }:
let
  notBroken = pkg: !(pkg.meta.broken or false);
  isDistributable = pkg: (pkg.meta.license or { redistributable = true; }).redistributable;
  hasPlatform = sys: pkg: lib.elem sys (pkg.meta.platforms or [ sys ]);
  filterValidPkgs =
    sys: pkgs:
    lib.filterAttrs (
      _: pkg: lib.isDerivation pkg && hasPlatform sys pkg && notBroken pkg && isDistributable pkg
    ) pkgs;

  getConfigTopLevel = _: cfg: cfg.config.system.build.toplevel;

  nixosConfigsForCI = lib.filterAttrs (name: _: name != "beehive") config.flake.nixosConfigurations;
in
{
  flake.hydraJobs = {
    pkgs = lib.mapAttrs filterValidPkgs (config.flake.packages or { });
    hosts = lib.mapAttrs getConfigTopLevel nixosConfigsForCI;
  };
}
