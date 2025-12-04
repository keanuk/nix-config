{pkgs, ...}: {
  environment.etc."nextcloud-admin-pass".text = "PWD";

  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.unstable.nextcloud32;
    hostName = "beehive";
    https = false;
    home = "/data/.state/nextcloud";
    datadir = "/data/nextcloud";
    autoUpdateApps.enable = true;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      trusted_domains = [
        "beehive"
        "localhost"
        "beehive.local"
        "10.19.5.10" # Main network IP
        "100.91.10.104" # Tailscale IP
        "192.168.15.5" # WireGuard IP
      ];
      trusted_proxies = ["127.0.0.1" "::1"];
    };
  };

  # Ensure Nextcloud services start after RAID is mounted
  # Using raid-online.target as a synchronization point with bindsTo for strong dependency
  systemd.services = {
    nextcloud-setup = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    nextcloud-cron = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    phpfpm-nextcloud = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
