{ pkgs, lib, secrets, ... }:

{
  imports = [
    ./packages.nix

    ../services/apparmor.nix
    ../services/geoclue2.nix
    ../services/tailscale.nix
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  zramSwap = {
    enable = true;
    priority = 1;
  };

  swapDevices = [ 
    { 
      device = "/swap/swapfile";
      priority = 0;
    } 
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      allowed-users = [ "@users" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  location.provider = "geoclue2";
  time.timeZone = lib.mkForce null;

  services = {
    automatic-timezoned.enable = true;
    fail2ban.enable = true;
    fwupd.enable = true;
    homed.enable = true;
    localtimed.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;
    resolved.enable = true;
    smartd.enable = true;
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
  
  security.audit.enable = true;

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
