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
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=10"
          "x-systemd.requires=tailscaled.service"
          "nfsvers=4"
        ];
      };
    };

    modules.nixos = {
      pc = config.flake.modules.nixos.nfs-client;
      laptop = config.flake.modules.nixos.nfs-client;
    };
  };
}
