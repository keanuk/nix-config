{ config, ... }:
{
  flake.modules.nixos.nextcloud =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      sops.secrets.nextcloud-admin-pass = {
        owner = "nextcloud";
        group = "nextcloud";
        mode = "0400";
      };

      services.nextcloud = {
        enable = true;
        configureRedis = true;
        package = pkgs.unstable.nextcloud33;
        hostName = lib.mkDefault "beehive";
        https = false;
        home = lib.mkDefault "/data/.state/nextcloud";
        datadir = lib.mkDefault "/data/nextcloud";
        autoUpdateApps.enable = true;
        database.createLocally = true;
        config = {
          dbtype = "pgsql";
          adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
        };
        settings = {
          trusted_domains = lib.mkDefault [
            "beehive"
            "localhost"
            "beehive.local"
            "10.19.5.10"
            "100.91.10.104"
            "192.168.15.5"
            "cloud.oranos.org"
          ];
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };

  flake.modules.nixos.server = config.flake.modules.nixos.nextcloud;
}
