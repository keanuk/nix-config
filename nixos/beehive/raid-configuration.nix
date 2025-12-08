{config, ...}: {
  # Define the beehive-specific sops secret for RAID password
  sops.secrets.beehive_raid_password = {
    mode = "0400";
  };

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

    script = let
      passwordFile = config.sops.secrets.beehive_raid_password.path;
    in ''
      set -euo pipefail

      /run/current-system/sw/bin/udevadm settle || true

      # Read password from sops secret file
      password=$(cat "${passwordFile}")

      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sda
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdb
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdc
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdd
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sde
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdf
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdg
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdh
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdi
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdj
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdk
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdl
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdm
      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdn

      printf '%s' "$password" | /run/current-system/sw/bin/bcachefs mount /dev/sda:/dev/sdb:/dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi:/dev/sdj:/dev/sdk:/dev/sdl:/dev/sdm:/dev/sdn /data
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "10min";
    };
  };
}
