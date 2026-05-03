{ config, ... }:
{
  flake = {
    modules.nixos.nfs-client = {
      fileSystems."/mnt/data" = {
        device = "beehive.local:/data";
        fsType = "nfs";
        options = [
          "rw"
          "noatime"
          "_netdev"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=10"
        ];
      };
    };

    modules.nixos.pc = config.flake.modules.nixos.nfs-client;
    modules.nixos.laptop = config.flake.modules.nixos.nfs-client;
  };
}
