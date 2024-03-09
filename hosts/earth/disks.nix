let
  defaultBtrfsOpts = [ "defaults" "compress=zstd" "ssd" "noatime" "nodiratime" ];
in
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              start = "0%";
              end = "1024MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
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
                    swap.swapfile.size = "32G";
                  };
                };
              };
            };
          };
        };
      };
      # data = {
      #  device = "/dev/sda";
      #  type = "disk";
      #  content = {
      #    type = "gpt";
      #    partitions = {
      #      data = {
      #        name = "data";
      #        size = "100%";
      #        content = {
      #          type = "filesystem";
      #          format = "bcachefs";
      #          mountpoint = "/data";
      #        };
      #      };
      #    };
      #  };
      # };
    };
  };
}
