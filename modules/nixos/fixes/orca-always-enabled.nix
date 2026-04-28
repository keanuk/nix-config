{
  flake.modules.nixos.fix-orca-always-enabled =
    { lib, ... }:
    {
      warnings = lib.optional true "Orca screen reader workaround (issue #462935) is still active. Check if upstream fix has landed. Last checked: 2025-07-28.";

      systemd.user.services.orca.wantedBy = lib.mkForce [ ];
    };
}
