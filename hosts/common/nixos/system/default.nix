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
    automatic-timezoned.enable = true;
    dbus.apparmor = "enabled";
    fail2ban.enable = true;
    fwupd.enable = true;
    geoclue2.enable = true;
    homed.enable = true;
    localtimed.enable = true;
    # netbird.enable = true;
    printing.enable = true;
    resolved = { 
      enable = true;
      extraConfig = ''
        DNS=45.90.28.0#c773e8.dns.nextdns.io
        DNS=2a07:a8c0::#c773e8.dns.nextdns.io
        DNS=45.90.30.0#c773e8.dns.nextdns.io
        DNS=2a07:a8c1::#c773e8.dns.nextdns.io
        DNSOverTLS=yes
      '';
    };
    smartd.enable = true;
    tailscale.enable = true;
  };

  systemd = {
    network.enable = true;
    oomd.enable = true;
  };

  networking = {
    firewall.enable = true;
    # firewall.trustedInterfaces = [ "wt0" ];
    networkmanager.enable = true;
  };
  
  # Security
  security = {
    apparmor = { 
      enable = true;
      killUnconfinedConfinables = true;
    };
    audit.enable = true;
  };

  # Power management
  services = {
    power-profiles-daemon.enable = true;
  	thermald.enable = true;
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

  # Internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };
}
