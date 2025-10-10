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
    # "recyclarr"
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
      accessibleFrom = [
        "10.19.5.0/24"
      ];
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

    recyclarr = {
      enable = false;
      package = pkgs.unstable.recyclarr;
    };

    sonarr = {
      enable = true;
      package = pkgs.unstable.sonarr;
      openFirewall = true;
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
