{pkgs, ...}: {
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    openFirewall = true;
    mediaLocation = "/data/immich";
  };

  # Ensure Immich services start after RAID is mounted
  # Using raid-online.target as a synchronization point with bindsTo for strong dependency
  systemd.services = {
    immich-server = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    immich-machine-learning = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
