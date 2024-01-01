{ config, pkgs, lib, ... }:

{
  # Boot
  boot = {
    # Init
    initrd.systemd.enable = true;

    # Installation
    loader.efi.canTouchEfiVariables = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
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
  };

  # Containers
  virtualisation = {
    containerd.enable = true;
    podman.enable = true;
  };

  # Console
  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
    packages = with pkgs; [
      terminus_font
    ];
  };
}
