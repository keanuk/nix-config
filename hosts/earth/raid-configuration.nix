{ ... }:

{
  systemd.services.mount-raid = {
    enable = true;
    description = "Mount RAID configuration";
    wantedBy = ["multi-user.target"];
    script = ''
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdc
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdd
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sde
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdf
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdg
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdh
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdi
      /run/current-system/sw/bin/bcachefs unlock -f /home/keanu/bcachefs-server.keyfile /dev/sdj
      /run/current-system/sw/bin/bcachefs mount -f /home/keanu/bcachefs-server.keyfile /dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi:/dev/sdj /data
    '';
  };
}
