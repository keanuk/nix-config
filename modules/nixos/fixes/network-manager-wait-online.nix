# Issue: https://github.com/NixOS/nixpkgs/issues/180175 (still open)
# Description: Replace NetworkManager-wait-online with plain nm-online so boot
#   does not block on the broken upstream wait-online unit.
# Status: not imported by any host (kept intentionally for future use)
# Last-checked: 2026-08-22
# Removal condition: Remove when nixpkgs #180175 is resolved.
{
  flake.modules.nixos.network-manager-wait-online =
    {
      pkgs,
      lib,
      ...
    }:
    {
      warnings = lib.optional true "NetworkManager wait-online workaround (issue #180175) may no longer be needed. Last checked: 2025-07-28.";

      systemd.services.NetworkManager-wait-online = {
        serviceConfig = {
          ExecStart = [
            ""
            "${pkgs.networkmanager}/bin/nm-online -q"
          ];
        };
      };
    };
}
