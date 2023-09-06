{ config, pkgs, lib, ... }:

{
  # Boot
  boot = {
    # Init
    initrd.systemd.enable = true;

    # Installation
    loader.efi.canTouchEfiVariables = true;
  };

  # Swap file
  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Systemd
  services = {
    dbus.apparmor = "enabled";
    fwupd.enable = true;
    homed.enable = true;
    smartd.enable = true;
  };

  systemd = {
    oomd.enable = true;
  };
  
  # Security
  security = {
    apparmor = { 
      enable = true;
      killUnconfinedConfinables = true;
    };
    audit.enable = true;
    auditd.enable = true;
  };

  # Containers
  virtualisation = {
    containerd.enable = true;
    podman.enable = true;
  };
}
