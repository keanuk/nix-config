{ ... }:

{
  systemd.services.mount-raid = {
    enable = true;
    description = "Mount RAID configuration";
    wantedBy = ["multi-user.target"];
    script = ''
      /run/current-system/sw/bin/bcachefs
    '';
  };
}
