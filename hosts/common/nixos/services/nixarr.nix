{
  inputs,
  pkgs,
  lib,
  ...
}: let
  services = [
    "wg"
    "transmission"
    "plex"
    # "jellyfin"
    # "jellyseerr"
    # "audiobookshelf"
    "autobrr"
    "bazarr"
    "lidarr"
    "prowlarr"
    "radarr"
    "recyclarr"
    "sonarr"
  ];
in {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;
    stateDir = "/data/.state/nixarr";
    mediaDir = "/data/nixarr";
    mediaUsers = [
      "keanu"
    ];

    vpn = {
      enable = true;
      wgConf = "/data/.secret/wg.conf";
    };

    transmission = {
      enable = true;
      package = pkgs.unstable.transmission_4;
      vpn.enable = true;
      credentialsFile = "/data/.secret/transmission/settings.json";
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
      enable = false;
      package = pkgs.unstable.jellyfin;
      openFirewall = true;
    };

    jellyseerr = {
      enable = false;
      package = pkgs.unstable.jellyseerr;
    };

    audiobookshelf = {
      enable = false;
      package = pkgs.unstable.audiobookshelf;
      openFirewall = true;
    };

    autobrr = {
      enable = true;
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
      configuration = {
        sonarr = {
          series = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            quality_definition = {
              type = "series";
            };
            delete_old_custom_formats = true;
            custom_formats = [
              {
                trash_ids = [
                  "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
                  "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
                ];
                assign_scores_to = [
                  {
                    name = "WEB-DL (1080p)";
                    score = -10000;
                  }
                ];
              }
            ];
          };
        };
        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition = {
              type = "movie";
            };
            delete_old_custom_formats = true;
            custom_formats = [
              {
                trash_ids = [
                  "570bc9ebecd92723d2d21500f4be314c" # Remaster
                  "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
                ];
                assign_scores_to = [
                  {
                    name = "HD Bluray + WEB";
                    score = 25;
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };

  systemd.services = lib.genAttrs services (_: {
    unitConfig = {
      After = ["mount-raid.service"];
      Requires = ["mount-raid.service"];
      AssertPathIsMountPoint = "/data";
    };
  });
}
