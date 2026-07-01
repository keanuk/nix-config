# Disko layout for ursa: multi-device btrfs spanning two NVMe drives, dual LUKS.
#
# Capacity: 2 TB NVMe (primary, holds ESP + LUKS root pool)
#         + 1 TB NVMe (secondary, LUKS) joined into the pool.
# Profile: data=single (~3 TB usable, NO data redundancy), metadata=raid1
#          (mkfs.btrfs default for multi-device — cheap metadata mirror).
# Unlock:  TPM2 on both devices, bound to PCR7 (Secure Boot state).
#          Enrolled at runtime via `systemd-cryptenroll --tpm2-device=auto
#          --tpm2-pcrs=7` on both LUKS headers. No keyfile, no passphrase
#          prompt — fully headless and hardware-bound.
#
# Recovery: if Secure Boot state changes (keys cleared, SB disabled), PCR7
# shifts and TPM2 won't release the key. Boot a previous generation (which
# still has the keyfile-based initrd from before Phase 2) or boot a live USB
# and re-enroll: `systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto
# --tpm2-pcrs=7 /dev/<partition>` (requires a remaining unlock slot — keep
# a passphrase slot as fallback if you want to be safe).
#
# WARNING: if you reformat with disko (destroy,format), the TPM2 enrollment
# is lost and must be re-done. The LUKS headers are recreated from scratch.
#
# Ordering note: disko serializes per-disk creates in attrset-key sort order, so
# `nvme1tb` (secondary) is formatted+opened BEFORE `nvme2tb` runs mkfs.btrfs,
# which absorbs /dev/mapper/crypted1 via extraArgs. If a future disko reorders,
# fallback: format primary only, then `btrfs device add /dev/mapper/crypted1 /`
# and `btrfs balance start -dconvert=single -mconvert=raid1` post-install.
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
      nvme1tb = {
        type = "disk";
        # 1 TB NVMe — secondary pool member. REPLACE with real by-id.
        device = "/dev/disk/by-id/nvme-Inland_QN450_NVMe_SSD_IB26AB1000P00252";
        content = {
          type = "gpt";
          partitions = {
            luks1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted1";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "tpm2-pcrs=7"
                  ];
                };
                initrdUnlock = true;
                # No inner content: the primary's mkfs.btrfs absorbs this mapper
                # (/dev/mapper/crypted1) into the multi-device pool via extraArgs.
              };
            };
          };
        };
      };

      nvme2tb = {
        type = "disk";
        # 2 TB NVMe — primary pool member (ESP + TPM2-unlocked LUKS root).
        # REPLACE with real by-id.
        device = "/dev/disk/by-id/nvme-KLEVV_CRAS_C910G_M.2_NVMe_SSD_2TB_2025100302007085";
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
            luks0 = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted0";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "tpm2-pcrs=7"
                  ];
                };
                # TPM2 unlock: both LUKS devices unlock via the system TPM2
                # module, bound to PCR7 (Secure Boot state). Enrollment was
                # done at runtime via `systemd-cryptenroll --tpm2-device=auto
                # --tpm2-pcrs=7`. The keyfile has been removed from the LUKS
                # headers and from the initrd — no plaintext key material in
                # the boot path. Clearing Secure Boot keys will invalidate
                # the TPM2 unlock; re-enroll with `systemd-cryptenroll
                # --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7`.
                initrdUnlock = true;
                content = {
                  type = "btrfs";
                  # -d single            : concatenate capacity (~3 TB usable)
                  # -m raid1             : mirrored metadata (cheap insurance)
                  # /dev/mapper/crypted1 : absorb the secondary NVMe into the pool
                  extraArgs = [
                    "-d"
                    "single"
                    "-m"
                    "raid1"
                    "/dev/mapper/crypted1"
                  ];
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
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "32G";
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
