_: let
  defaultBcachefsOpts = ["defaults" "compress=lz4" "ssd" "noatime" "nodiratime"];
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-ADATA_LEGEND_800_GOLD_2O412L121NKC";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=0077"];
              };
            };
            root = {
              name = "root";
              end = "-32G";
              content = {
                type = "bcachefs";
                filesystem = "default_subvolumes";
                extraFormatArgs = [
                  "--force"
                ];
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
    bcachefs_filesystems = {
      default_subvolumes = {
        type = "bcachefs_filesystem";
        passwordFile = "/tmp/secret.key";
        extraFormatArgs = [
          "--compression=lz4"
          "--background_compression=lz4"
        ];
        subvolumes = {
          "@" = {
            mountpoint = "/";
            mountOptions = defaultBcachefsOpts;
          };
          "@nix" = {
            mountpoint = "/nix";
            mountOptions = defaultBcachefsOpts;
          };
          "@home" = {
            mountpoint = "/home";
            mountOptions = defaultBcachefsOpts;
          };
          "@log" = {
            mountpoint = "/var/log";
            mountOptions = defaultBcachefsOpts;
          };
          "@persist" = {
            mountpoint = "/persist";
            mountOptions = defaultBcachefsOpts;
          };
          "@snapshots" = {
            mountpoint = "/.snapshots";
            mountOptions = defaultBcachefsOpts;
          };
        };
      };
    };
  };
}
