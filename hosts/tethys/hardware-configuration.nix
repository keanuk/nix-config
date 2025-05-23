# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "ums_realtek" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@snapshots"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@var_log"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/8a943e1a-9063-4201-bbd5-14092bcabaff";
    fsType = "btrfs";
    options = ["subvol=@swap"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FA12-A2E8";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
