# Disko layout for ursa: multi-device btrfs spanning two NVMe drives, dual LUKS.
#
# Capacity: 2 TB NVMe (primary, holds ESP + passphrase-unlocked LUKS root pool)
#         + 1 TB NVMe (secondary, keyfile-unlocked LUKS) joined into the pool.
# Profile: data=single (~3 TB usable, NO data redundancy), metadata=raid1
#          (mkfs.btrfs default for multi-device — cheap metadata mirror).
# Boot:    one passphrase prompt (crypted0); crypted1 unlocks via /crypto-keyfile
#          baked into the initrd (see boot.initrd.secrets below).
#
# BEFORE FIRST INSTALL you MUST:
#   1. Fill in the two placeholder device by-id strings below.
#   2. Generate the real LUKS keyfile (random bytes):
#        dd if=/dev/urandom bs=512 count=4 of=modules/hosts/ursa/crypto-keyfile
#   3. Force-add it so the flake can see it (flakes only track git-indexed files):
#        git add -f modules/hosts/ursa/crypto-keyfile
#   4. Copy the SAME bytes to the install host before running disko:
#        sudo cp modules/hosts/ursa/crypto-keyfile /crypto-keyfile
#      disko formats crypted1 from install-host /crypto-keyfile; boot reads
#      the keyfile baked into the initrd from the repo copy. Bytes must match.
#
# Security: the keyfile only gates the SECONDARY NVMe. The pool is unmountable
# without the primary passphrase, so leaking the keyfile alone exposes nothing.
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
        device = "/dev/disk/by-id/nvme-URSA_OS_NVME1_1TB_PLACEHOLDER";
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
                  # Unlocked at boot by this keyfile (baked into initrd below).
                  # No passphrase prompt for this device.
                  keyFile = "/crypto-keyfile";
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
        # 2 TB NVMe — primary pool member (ESP + passphrase-unlocked LUKS root).
        # REPLACE with real by-id.
        device = "/dev/disk/by-id/nvme-URSA_OS_NVME0_2TB_PLACEHOLDER";
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
                  keyFile = "/crypto-keyfile";
                };
                # Phase 1 (bootstrap): both LUKS devices unlock from /crypto-keyfile
                # baked into the initrd, so boot is fully headless. After the user
                # manually enrolls TPM2 via `systemd-cryptenroll --tpm2-device=auto
                # --tpm2-pcrs=7` on both LUKS headers at runtime, Phase 2 will DROP
                # this keyFile and the boot.initrd.secrets line and switch to
                # `crypttabExtraOpts = ["tpm2-device=auto" "tpm2-pcrs=7"]`. Do not
                # enable TPM2 options in disko before runtime enrollment is done —
                # disko cannot enroll TPM2 at format time (no native support), and
                # shipping tpm2-device=auto before the header has a tpm2 slot would
                # make boot fail.
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

  # Bake the LUKS keyfile into the initrd so crypted1 unlocks headless after the
  # primary passphrase is entered. The file must be git-tracked (flakes only see
  # tracked files) — generate the real key with `dd` and `git add -f` it before
  # building/installing ursa. See the header comment for the exact bootstrap.
  boot.initrd.secrets."/crypto-keyfile" = ./crypto-keyfile;
}
