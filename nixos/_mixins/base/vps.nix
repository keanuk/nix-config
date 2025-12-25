{inputs, ...}: {
  imports = [
    inputs.vscode-server.nixosModules.default

    ../services/openssh
  ];

  services.vscode-server.enable = true;

  # Minimal VPS overrides
  services.printing.enable = false;
  services.avahi.enable = false;
  services.power-profiles-daemon.enable = false;
  hardware.bluetooth.enable = false;
  boot.plymouth.enable = false;
}
