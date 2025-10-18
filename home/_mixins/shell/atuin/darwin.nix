{lib, ...}: {
  programs.atuin.daemon.enable = lib.mkForce false;
}
