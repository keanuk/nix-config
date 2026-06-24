{ config, inputs, ... }:
{
  flake.modules.nixos.nixarr =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nixarr.nixosModules.default
      ];

      nixarr = {
        enable = true;
        stateDir = lib.mkDefault "/data/.state/nixarr";
        mediaDir = lib.mkDefault "/data/nixarr";
        mediaUsers = [
          "keanu"
        ];

        vpn = {
          enable = true;
          wgConf = lib.mkDefault "/data/.secret/wg.conf";
          accessibleFrom = [
            "10.19.5.0/24"
          ];
        };

        transmission = {
          enable = true;
          package = pkgs.unstable.transmission_4;
          vpn.enable = true;
          peerPort = 51413;
          credentialsFile = lib.mkDefault "/data/.secret/transmission/settings.json";
          extraAllowedIps = [
            "10.19.5.*"
          ];
        };

        plex = {
          enable = true;
          package = pkgs.unstable.plex;
          openFirewall = true;
        };

        jellyfin = {
          enable = true;
          package = pkgs.unstable.jellyfin;
          openFirewall = true;
        };

        seerr = {
          enable = true;
          package = pkgs.unstable.seerr;
        };

        audiobookshelf = {
          enable = true;
          package = pkgs.unstable.audiobookshelf;
          openFirewall = true;
        };

        shelfmark = {
          enable = true;
          package = pkgs.unstable.shelfmark;
          openFirewall = true;
        };

        autobrr = {
          enable = false;
          package = pkgs.unstable.autobrr;
        };

        bazarr = {
          enable = true;
          package = pkgs.unstable.bazarr;
          openFirewall = true;
        };

        lidarr = {
          enable = true;
          package = pkgs.unstable.lidarr;
          openFirewall = true;
        };

        prowlarr = {
          enable = true;
          package = pkgs.unstable.prowlarr;
          openFirewall = true;
        };

        radarr = {
          enable = true;
          package = pkgs.unstable.radarr;
          openFirewall = true;
        };

        sonarr = {
          enable = true;
          package = pkgs.unstable.sonarr;
          openFirewall = true;
        };

        recyclarr = {
          enable = true;
          package = pkgs.unstable.recyclarr;
          schedule = "daily";
          configFile = ./recyclarr.yaml;
        };

        anchorr = {
          enable = false;
          package = pkgs.unstable.anchorr;
          openFirewall = true;
        };
      };

      # Ensure all Nixarr services have access to the media group
      users.users =
        lib.genAttrs
          [
            "transmission"
            "plex"
            "bazarr"
            "lidarr"
            "prowlarr"
            "radarr"
            "recyclarr"
            "sonarr"
          ]
          (_: {
            extraGroups = [ "media" ];
          });
    };

  flake.modules.nixos.server = config.flake.modules.nixos.nixarr;
}
