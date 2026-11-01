# Issue: https://github.com/nix-media-server/nixarr/issues/186 (PR #190 open)
# Description: nixarr's `nixarr-py` looks up `config.nixarr.jellyfin.package.version`
#   in a hardcoded SHA256 table in `nixarr/lib/nixarr-py/python-deps.nix`. When
#   `pkgs.unstable.jellyfin` bumps ahead of nixarr's hash table (e.g. 12.4 vs 12.2),
#   evaluation fails with `attribute '"12.4"' missing`. Build `nixarr-py` against
#   `pkgs.stable.jellyfin` so the Jellyfin server can stay on unstable without
#   breaking `nixarr-py` evaluation.
# Status: active
# Last-checked: 2026-11-01
# Removal condition: Remove if nixarr stops coupling `nixarr-py` to a hardcoded
#   per-version hash table or when `nixarr.jellyfin.package` no longer uses unstable.
{ config, inputs, ... }:
{
  flake.modules.nixos.nixarr-py-jellyfin-hash =
    {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
    lib.mkIf ((options ? nixarr) && config.nixarr.enable) {
      nixarr.nixarr-py.package = pkgs.callPackage "${inputs.nixarr}/nixarr/lib/nixarr-py" {
        inherit (pkgs.stable) jellyfin;
      };
    };

  flake.modules.nixos.nixarr = config.flake.modules.nixos.nixarr-py-jellyfin-hash;
}
