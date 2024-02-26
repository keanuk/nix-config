{ config, pkgs, lib, secrets, ... }:

{
  boot = {
    initrd.systemd.enable = true;
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

  swapDevices = [ { device = "/swap/swapfile"; } ];

  location.provider = "geoclue2";
  time.timeZone = lib.mkForce null;

  services = {
    automatic-timezoned.enable = true;
    dbus.apparmor = "enabled";
    fail2ban.enable = true;
    fwupd.enable = true;
    geoclue2 = {
      enable = true;
      geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=${secrets.google_maps.token}";
    };
    homed.enable = true;
    localtimed.enable = true;
    # netbird.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;
    resolved = { 
      enable = true;
      # extraConfig = ''
      #   DNS=45.90.28.0#${secrets.nextdns.id}.dns.nextdns.io
      #   DNS=2a07:a8c0::#${secrets.nextdns.id}.dns.nextdns.io
      #   DNS=45.90.30.0#${secrets.nextdns.id}.dns.nextdns.io
      #   DNS=2a07:a8c1::#${secrets.nextdns.id}.dns.nextdns.io
      #   DNSOverTLS=yes
      # '';
    };
    smartd.enable = true;
    tailscale.enable = true;
    thermald.enable = true;
  };

  systemd = {
    # network.enable = true;
    oomd.enable = true;
  };

  networking = {
    firewall.enable = true;
    # firewall.trustedInterfaces = [ "wt0" ];
    networkmanager.enable = true;
  };

  # Workaround for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  
  security = {
    apparmor = { 
      enable = true;
      killUnconfinedConfinables = true;
    };
    audit.enable = true;
  };

  virtualisation = {
    containerd.enable = true;
    podman.enable = true;
  };

  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    useXkbConfig = true;
    packages = with pkgs; [
      terminus_font
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };
}
