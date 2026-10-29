# Issue: https://github.com/NixOS/nixpkgs/pull/573479 (sphinx-hook ignores all
#   but the first element of sphinxBuilders when __structuredAttrs = true)
# Description: buildPythonPackage enabled __structuredAttrs = true on
#   nixos-unstable, which turns `sphinxBuilders = [ "html" "man" ]` in
#   python3Packages.reuse into a bash array. sphinx-hook expands `${sphinxBuilders-}`
#   (only the first element, "html"), skipping the "man" builder and failing the
#   derivation because the "man" output path is never produced.
#   Pass sphinxBuilders as a single space-separated string ("html man") on reuse,
#   matching the upstream workaround used in borgbackup, khal, and todoman.
# Status: active
# Last-checked: 2026-10-28
# Removal condition: Remove when nixpkgs PR #573479 (or equivalent fix in
#   reuse / sphinx-hook) lands in nixos-unstable and python3Packages.reuse
#   builds its man output without overrides.
{ config, ... }:
{
  flake.modules.homeManager.amberol-reuse-sphinx =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf config.services.amberol.enable {
      services.amberol.package = pkgs.amberol.override {
        reuse = pkgs.reuse.overrideAttrs {
          sphinxBuilders = [ "html man" ];
        };
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.amberol-reuse-sphinx;
}
