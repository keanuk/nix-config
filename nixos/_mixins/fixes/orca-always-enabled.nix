# Orca screen reader always enabled fix
# Issue: https://github.com/NixOS/nixpkgs/issues/462935
# Upstream PR: (check issue for any related PRs)
# Workaround: Force disable orca from being automatically wanted by user session
# Status: temporary - should be resolved in future nixpkgs versions
# Last checked: 2024-01-01
# Remove after: nixpkgs > 25.05 or when upstream issue is closed
{lib, ...}: {
  systemd.user.services.orca.wantedBy = lib.mkForce [];
}
