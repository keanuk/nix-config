# Orca screen reader always enabled fix
# Issue: https://github.com/NixOS/nixpkgs/issues/462935
# Upstream PR: (check issue for any related PRs)
# Workaround: Force disable orca from being automatically wanted by user session
# Status: temporary - should be resolved in future nixpkgs versions
# Last checked: 2025-07-28
# Remove after: nixpkgs > 25.05 or when upstream issue #462935 is closed
{ lib, ... }:
{
  warnings = lib.optional true "Orca screen reader workaround (issue #462935) is still active. Check if upstream fix has landed. Last checked: 2025-07-28.";

  systemd.user.services.orca.wantedBy = lib.mkForce [ ];
}
