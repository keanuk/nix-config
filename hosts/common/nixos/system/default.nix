{ config, pkgs, lib, ... }:

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

  services = {
    automatic-timezoned.enable = true;
    dbus.apparmor = "enabled";
    fail2ban.enable = true;
    fwupd.enable = true;
    geoclue2 = {
      enable = true;
      enableDemoAgent = lib.mkForce true;
      geoProviderUrl = "https://location.services.mozilla.com/v1/geolocate?key=geoclue";
      enableWifi = false;
      appConfig.localtimed.isAllowed = true;
      appConfig.localtimed.isSystem = true;
    };
    homed.enable = true;
    localtimed.enable = true;
    # netbird.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;
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

  location.provider = "geoclue2";
  time.timeZone = lib.mkForce null;
  
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
