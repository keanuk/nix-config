{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.vscode-server.nixosModules.default

    ../services/openssh
  ];

  services = {
    vscode-server.enable = true;
    printing.enable = lib.mkForce false;
    avahi.enable = lib.mkForce false;
    power-profiles-daemon.enable = lib.mkForce false;
  };
  hardware.bluetooth.enable = lib.mkForce false;
  boot.plymouth.enable = lib.mkForce false;
}
