# NetworkManager wait-online timeout fix
# Issue: https://github.com/NixOS/nixpkgs/issues/180175
# Upstream PR: (check issue for any related PRs)
# Workaround: Override ExecStart to use nm-online -q without timeout
# Status: temporary - should be resolved in future nixpkgs versions
# Last checked: 2024-01-01
# Remove after: nixpkgs > 24.11 or when upstream issue is closed
{ pkgs, ... }:
{
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.networkmanager}/bin/nm-online -q"
      ];
    };
  };
}
