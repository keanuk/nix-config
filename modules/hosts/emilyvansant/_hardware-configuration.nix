{
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  # Placeholder - disko handles actual mounts
  fileSystems."/" = lib.mkDefault {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  # Hetzner VPS network config
  networking.useDHCP = lib.mkForce true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
