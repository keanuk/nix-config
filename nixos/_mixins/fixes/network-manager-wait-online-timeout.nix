# NetworkManager wait-online timeout fix
# Issue: https://github.com/NixOS/nixpkgs/issues/180175
# Upstream PR: (check issue for any related PRs)
# Workaround: Override ExecStart to use nm-online -q without timeout
# Status: temporary - should be resolved in future nixpkgs versions
# Last checked: 2025-07-28
# Remove after: Check if upstream issue #180175 is closed; we are past 24.11
{ pkgs, lib, ... }:
{
  # TODO: Verify whether this workaround is still needed on nixos-unstable.
  # The original comment said "Remove after: nixpkgs > 24.11" and we are now
  # well past that. Test removing this file and see if boot still hangs.
  warnings = lib.optional true "NetworkManager wait-online workaround (issue #180175) may no longer be needed. Last checked: 2025-07-28.";

  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.networkmanager}/bin/nm-online -q"
      ];
    };
  };
}
