{ ... }:

{
  systemd.services.mount-raid = {
    description = "Mount RAID configuration";
    script = /run/current-system/sw/bin/bcachefs ;
    wantedBy = ["multi-user.target"];
  };
}
