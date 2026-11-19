{ lib, config, ... }:
let
  notBroken = pkg: !(pkg.meta.broken or false);
  isDistributable =
    pkg: lib.all (l: l.redistributable or true) (lib.toList (pkg.meta.license or [ ]));
  hasPlatform = sys: pkg: lib.elem sys (pkg.meta.platforms or [ sys ]);
  filterValidPkgs =
    sys: pkgs:
    lib.filterAttrs (
      _: pkg: lib.isDerivation pkg && hasPlatform sys pkg && notBroken pkg && isDistributable pkg
    ) pkgs;
in
{
  flake.hydraJobs = {
    pkgs = lib.mapAttrs filterValidPkgs (config.flake.packages or { });
  };
}
