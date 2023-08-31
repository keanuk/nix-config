{ config, pkgs, lib, ... }:

{
  # Boot
  boot = {
    # Animation
     plymouth.enable = true;

    # Init
    initrd.systemd.enable = true;

    # Installation
    loader.efi.canTouchEfiVariables = true;

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Secure Boot
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };

  # Upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    channel = "https://channels.nixos.org/nixos-unstable";
  };

  # Mount options
  fileSystems = {
    "/".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/nix".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/home".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/.snapshots".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/var/log".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/swap".options = [ "noatime" ];
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

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };
}
