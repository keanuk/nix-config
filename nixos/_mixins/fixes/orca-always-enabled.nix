{lib, ...}: {
  # workaround for https://github.com/NixOS/nixpkgs/issues/462935
  systemd.user.services.orca.wantedBy = lib.mkForce [];
}
