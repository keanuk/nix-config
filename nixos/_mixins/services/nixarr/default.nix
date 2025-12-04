{
  inputs,
  pkgs,
  lib,
  ...
}: let
  # Services that need to wait for the RAID array to be mounted
  # These are the actual systemd service names created by nixarr
  raidDependentServices = [
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

  # VPN namespace service name (from vpn-confinement module via nixarr.vpn)
  # The vpnNamespaces.wg creates a service called "wg.service"
  vpnNamespaceServices = [
    "wg"
  ];

  # Common dependency configuration for services that need the RAID
  raidDependencyConfig = {
    after = ["raid-online.target"];
    bindsTo = ["raid-online.target"];
    unitConfig.AssertPathIsMountPoint = "/data";
  };
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
  };

  # Configure all nixarr services to depend on the RAID being online
  systemd.services = lib.mkMerge [
    # Regular nixarr services
    (lib.genAttrs raidDependentServices (_: raidDependencyConfig))

    # VPN namespace services need the RAID because the wg config is stored on /data
    (lib.genAttrs vpnNamespaceServices (_: raidDependencyConfig))
  ];
}
