{inputs, ...}: {
  imports = [
    inputs.vscode-server.nixosModules.default

    ../services/openssh
  ];

  services = {
    vscode-server.enable = true;
    printing.enable = false;
    avahi.enable = false;
    power-profiles-daemon.enable = false;
  };
  hardware.bluetooth.enable = false;
  boot.plymouth.enable = false;
}
