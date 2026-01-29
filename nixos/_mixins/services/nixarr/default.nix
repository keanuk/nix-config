{
  inputs,
  pkgs,
  lib,
  ...
}:
let
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

  vpnNamespaceServices = [
    "wg"
  ];

  # Use "requires" instead of "bindsTo" to avoid cascading stops during nixos-rebuild switch
  # bindsTo would cause all these services to stop if raid-online.target is touched
  raidDependencyConfig = {
    after = [ "raid-online.target" ];
    requires = [ "raid-online.target" ];
    unitConfig.AssertPathIsMountPoint = "/data";
  };
in
{
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

  systemd.services = lib.mkMerge [
    (lib.genAttrs raidDependentServices (_: raidDependencyConfig))
    (lib.genAttrs vpnNamespaceServices (_: raidDependencyConfig))
  ];
}
