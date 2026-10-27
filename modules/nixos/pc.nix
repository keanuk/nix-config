{
  # smartd and openssh opt themselves into pc from their own files.
  flake.modules.nixos.pc = {
    services.openssh.openFirewall = false;
    hardware.i2c.enable = true;
    users.users.keanu.extraGroups = [ "i2c" ];
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
