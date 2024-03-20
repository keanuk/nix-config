{ inputs, outputs, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix

    ../services/apparmor.nix
    ../services/btrfs.nix
    ../services/tailscale.nix
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  zramSwap = {
    enable = true;
    priority = 5;
  };

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

  nixpkgs.overlays = [
    outputs.overlays.unstable-packages
  ];

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
    nftables.enable = true;
  };

  security.audit.enable = true;

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
