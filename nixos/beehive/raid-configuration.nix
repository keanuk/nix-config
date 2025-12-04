{secrets, ...}: {
  # Define a target that other services can depend on
  # This provides a clean synchronization point for services that need the RAID
  systemd.targets.raid-online = {
    description = "RAID Array Mounted and Ready";
    after = ["mount-raid.service"];
    requires = ["mount-raid.service"];
    wantedBy = ["multi-user.target"];
  };

  systemd.services.mount-raid = {
    enable = true;
    description = "Mount RAID configuration";
    wantedBy = ["multi-user.target"];
    restartIfChanged = false;

    unitConfig = {
      After = ["local-fs-pre.target"];
      Wants = ["local-fs-pre.target"];
    };

    script = ''
      set -euo pipefail

      /run/current-system/sw/bin/udevadm settle || true

      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sda
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdb
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdc
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdd
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sde
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdf
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdg
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdh
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdi
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdj
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdk
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdl
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdm
      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdn

      printf '%s' '${secrets.beehive_raid.password}' | /run/current-system/sw/bin/bcachefs mount /dev/sda:/dev/sdb:/dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi:/dev/sdj:/dev/sdk:/dev/sdl:/dev/sdm:/dev/sdn /data
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "10min";
    };
  };
}
