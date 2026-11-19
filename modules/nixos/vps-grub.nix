{ config, ... }:
let
  defaultBtrfsOpts = [
    "defaults"
    "compress=zstd"
    "noatime"
    "nodiratime"
  ];
in
{
  flake.modules.nixos.vps-grub = {
    imports = with config.flake.modules.nixos; [ vps ];

    boot.loader.grub = {
      enable = true;
      efiSupport = false;
    };
  };

  # Shared Hetzner Cloud x86_64 VPS hardware + disko btrfs layout (BIOS GRUB).
  flake.modules.nixos.hetzner-vps =
    { lib, modulesPath, ... }:
    {
      imports = [
        config.flake.modules.nixos.vps-grub
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

      networking.useDHCP = lib.mkForce true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      disko.devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/sda";
            content = {
              type = "gpt";
              partitions = {
                boot = {
                  size = "1M";
                  type = "EF02"; # BIOS boot partition for GRUB
                  priority = 1;
                };
                root = {
                  size = "100%";
                  priority = 2;
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "@" = {
                        mountpoint = "/";
                        mountOptions = defaultBtrfsOpts;
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = defaultBtrfsOpts;
                      };
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = defaultBtrfsOpts;
                      };
                      "@var" = {
                        mountpoint = "/var";
                        mountOptions = defaultBtrfsOpts;
                      };
                      "@snapshots" = {
                        mountpoint = "/.snapshots";
                        mountOptions = defaultBtrfsOpts;
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
}
