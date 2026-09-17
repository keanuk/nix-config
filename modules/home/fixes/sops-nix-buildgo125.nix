# Issue: https://github.com/Mic92/sops-nix/issues/...  (sops-install-secrets uses
#   buildGo125Module, removed from nixos-unstable 2026-09)
# Description: same as modules/nixos/fixes/sops-nix-buildgo125.nix, but for the
#   home-manager side: the HM sops module defaults sops.package to
#   (pkgs.callPackage ../.. {}).sops-install-secrets, which nixpkgs removed
#   (Go 1.25 is EOL), so any host on a new enough unstable fails with
#   "Go 1.25 is end-of-life, and 'buildGo125Module' has been removed." Override
#   sops.package with the same source built via the current `buildGoModule`.
# Status: workaround; sops-install-secrets has no release since the builder
#   removal and upstream still uses buildGo125Module.
# Last-checked: 2026-09-17
# Removal condition: when upstream sops-nix builds sops-install-secrets with a
#   builder that exists in current nixos-unstable (drop the override then).
{ config, inputs, ... }:
{
  flake.modules.homeManager.sops-nix-buildgo125 =
    {
      lib,
      pkgs,
      ...
    }:
    {
      sops.package =
        let
          src = lib.sourceByRegex inputs.sops-nix [
            "go\\.(mod|sum)"
            "pkgs"
            "pkgs/sops-install-secrets.*"
          ];
        in
        pkgs.buildGoModule {
          pname = "sops-install-secrets";
          version = "0.0.1";
          inherit src;
          subPackages = [ "pkgs/sops-install-secrets" ];
          doCheck = false;
          vendorHash = "sha256-SXOd+0yh0DQr3uLVQBdw07J9j5HNuFJSOajDul1B1qo=";
        };
    };

  flake.modules.homeManager.sops = config.flake.modules.homeManager.sops-nix-buildgo125;
}
