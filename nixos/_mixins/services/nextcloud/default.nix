{
  pkgs,
  config,
  ...
}: {
  # Configure sops secret with correct ownership for nextcloud
  sops.secrets.nextcloud-admin-pass = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
  };

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
      adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
    };
    settings = {
      trusted_domains = [
        "beehive"
        "localhost"
        "beehive.local"
        "10.19.5.10" # Main network IP
        "100.91.10.104" # Tailscale IP
        "192.168.15.5" # WireGuard IP
        "cloud.oranos.me" # Cloudflare Tunnel domain (update with your actual domain)
      ];
      trusted_proxies = ["127.0.0.1" "::1"];
    };
  };

  # Ensure Nextcloud services start after RAID is mounted and sops secrets are available
  # Using raid-online.target as a synchronization point with bindsTo for strong dependency
  systemd.services = {
    nextcloud-setup = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    nextcloud-cron = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    phpfpm-nextcloud = {
      after = ["raid-online.target" "systemd-tmpfiles-setup.service" "postgresql.service"];
      bindsTo = ["raid-online.target"];
      requires = ["systemd-tmpfiles-setup.service" "postgresql.service"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
