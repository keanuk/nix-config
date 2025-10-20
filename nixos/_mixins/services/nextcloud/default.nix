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
        "10.19.5.10"      # Main network IP
        "100.91.10.104"   # Tailscale IP
        "192.168.15.5"    # WireGuard IP
      ];
      trusted_proxies = ["127.0.0.1" "::1"];
    };
  };

  # Ensure Nextcloud services start after RAID is mounted and tmpfiles are created
  systemd.services.nextcloud-setup = {
    after = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
    requires = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
  };

  systemd.services.nextcloud-cron = {
    after = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
    requires = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
  };

  systemd.services.phpfpm-nextcloud = {
    after = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
    requires = ["mount-raid.service" "systemd-tmpfiles-setup.service" "postgresql.service"];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
