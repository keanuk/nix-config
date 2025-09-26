{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;
    stateDir = "/data/.state/nixarr";
    mediaDir = "/data/Media";
    mediaUsers = [
      "keanu"
      "plex"
      "transmission"
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
      peerPort = 51413;
      uiPort = 9091;
      extraAllowedIps = [
        "10.19.5.*"
      ];
    };

    plex = {
      enable = false;
      package = pkgs.unstable.plex;
      openFirewall = true;
    };

    jellyfin = {
      enable = true;
      package = pkgs.unstable.jellyfin;
      openFirewall = true;
    };

    audiobookshelf = {
      enable = true;
      package = pkgs.unstable.audiobookshelf;
      openFirewall = true;
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
  };
}
