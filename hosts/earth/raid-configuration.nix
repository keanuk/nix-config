{secrets, ...}: {
  systemd.services.mount-raid = {
    enable = true;
    description = "Mount RAID configuration";
    wantedBy = ["default.target"];
    restartIfChanged = false;
    script = ''
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdc"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdd"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sde"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdf"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdg"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdh"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdi"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdj"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdk"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdl"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdm"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdn"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdo"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs unlock -k session /dev/sdp"
      /run/current-system/sw/bin/bash -c "echo '${secrets.earth_raid.password}' | /run/current-system/sw/bin/bcachefs mount /dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi:/dev/sdj:/dev/sdk:/dev/sdl:/dev/sdm:/dev/sdn:/dev/sdo:/dev/sdp /data"
    '';
    serviceConfig = {
      RemainAfterExit = true;
      Type = "oneshot";
    };
  };
}
