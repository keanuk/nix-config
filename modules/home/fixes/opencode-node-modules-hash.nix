# Issue: https://github.com/NixOS/nixpkgs/issues (opencode 2.2.5 node_modules FOD hash mismatch)
# Description: `pkgs.unstable.opencode` (2.2.5) specifies an outdated fixed-output
#   derivation hash (`sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc=`) for
#   `opencode-node_modules-2.2.5`, causing builds of `opencode` and `opencode-desktop`
#   to fail with a hash mismatch. Override `node_modules.outputHash` when the broken
#   hash is present.
# Status: active
# Last-checked: 2026-11-05
# Removal condition: Remove when nixpkgs updates `opencode` (or its `node_modules`
#   `outputHash`) in nixos-unstable so `pkgs.unstable.opencode` builds without overrides.
{ config, ... }:
{
  flake.modules.homeManager.opencode-node-modules-hash =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      brokenHash = "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc=";
      inherit (pkgs.unstable) opencode;
    in
    lib.mkIf
      (config.programs.opencode.enable && (opencode.node_modules.outputHash or null) == brokenHash)
      {
        programs.opencode.package = opencode.overrideAttrs (old: {
          node_modules = old.node_modules.overrideAttrs {
            outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
          };
        });
      };

  flake.modules.homeManager.opencode = config.flake.modules.homeManager.opencode-node-modules-hash;
}
