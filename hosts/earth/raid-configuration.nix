{ ... }:

{
  systemd.services.mount-raid = {
    enable = true;
    description = "Mount RAID configuration";
    script = /run/current-system/sw/bin/bcachefs ;
    wantedBy = ["multi-user.target"];
  };
}
