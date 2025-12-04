{pkgs, ...}: {
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    openFirewall = true;
    mediaLocation = "/data/immich";
  };

  # Ensure the immich media directory and required subdirectories exist with correct permissions
  # This is required when using a non-default mediaLocation
  # Immich checks for .immich files in these subdirectories to verify mount integrity
  # The .immich files are created with 'f' (create if not exists) to satisfy Immich's mount checks
  # when the database already has mountChecks enabled from a previous installation
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

  # Ensure Immich services start after RAID is mounted
  # Using raid-online.target as a synchronization point with bindsTo for strong dependency
  systemd.services = {
    immich-server = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    immich-machine-learning = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };
  };
}
