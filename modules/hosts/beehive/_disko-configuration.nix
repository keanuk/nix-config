# Disko layout for beehive: single 1 TB NVMe, LUKS-encrypted btrfs.
#
# Unlock:  TPM2 bound to PCR7 (Secure Boot state), enrolled post-install:
#            sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
#              /dev/disk/by-id/nvme-CT1000P3PSSD8_25054DEBB585-part2
#          Slot 0 keeps the interactive passphrase entered during `disko
#          --mode disko` — keep it as the recovery slot.
#
# Recovery: PCR7 shifts when Secure Boot is toggled or a firmware dbx update
#           lands via fwupd — the TPM then refuses to release the key. Unlock
#           with the passphrase and re-enroll:
#             sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto \
#               --tpm2-pcrs=7 /dev/disk/by-id/nvme-CT1000P3PSSD8_25054DEBB585-part2
#
# WARNING: reformatting with disko (destroy,format) recreates the LUKS header;
#          the TPM2 enrollment is lost and must be re-done.
_:
let
  defaultBtrfsOpts = [
    "defaults"
    "compress=zstd"
    "ssd"
    "noatime"
    "nodiratime"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25054DEBB585";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "tpm2-pcrs=7"
                  ];
                };
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
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "16G";
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

  # Enable TPM2 support in the initrd so the libcryptsetup-token-systemd-tpm2
  # plugin is available for systemd-cryptsetup to read the TPM2 slot.
  boot.initrd.systemd.tpm2.enable = true;
}
