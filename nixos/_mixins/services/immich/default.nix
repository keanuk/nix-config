{ pkgs, ... }:
{
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    openFirewall = true;
    host = "0.0.0.0";
    port = 2283;
    mediaLocation = "/data/immich";
  };

  systemd.tmpfiles.rules = [
    "d /data/immich 0750 immich immich -"
    "d /data/immich/encoded-video 0750 immich immich -"
    "d /data/immich/library 0750 immich immich -"
    "d /data/immich/profile 0750 immich immich -"
    "d /data/immich/thumbs 0750 immich immich -"
    "d /data/immich/upload 0750 immich immich -"
    "d /data/immich/backups 0750 immich immich -"
    # Create .immich mount check files (Immich expects these to exist)
    "f /data/immich/encoded-video/.immich 0640 immich immich -"
    "f /data/immich/library/.immich 0640 immich immich -"
    "f /data/immich/profile/.immich 0640 immich immich -"
    "f /data/immich/thumbs/.immich 0640 immich immich -"
    "f /data/immich/upload/.immich 0640 immich immich -"
    "f /data/immich/backups/.immich 0640 immich immich -"
  ];

  systemd.services = {
    immich-server = {
      after = [ "raid-online.target" ];
      requires = [ "raid-online.target" ];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    immich-machine-learning = {
      after = [ "raid-online.target" ];
      requires = [ "raid-online.target" ];
      unitConfig.AssertPathIsMountPoint = "/data";
    };
  };
}
