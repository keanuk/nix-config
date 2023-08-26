{ config, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # SecureBoot
  boot.bootspec.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use boot animation
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

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
  services.homed.enable = true;

  # Security
  security.apparmor.enable = true;
  services.dbus.apparmor = "enabled";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
}
