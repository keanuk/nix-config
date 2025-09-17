{inputs, pkgs, ...}: {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;
    mediaDir = "/data/Media";
    stateDir = "/data/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = "/data/.secret/wg.conf";
    };

    transmission = {
      enable = true;
      package = pkgs.unstable.transmission_4;
      vpn.enable = true;
      peerPort = 51413;
      uiPort = 9091;
      extraAllowedIps = [
        "10.19.5.*"
      ];
    };

    jellyfin = {
      enable = false;
      package = pkgs.unstable.jellyfin;
      openFirewall = true;
      stateDir = "/data/.state/jellyfin";
    };

    audiobookshelf = {
      enable = true;
      package = pkgs.unstable.audiobookshelf;
      openFirewall = true;
      stateDir = "/data/.state/audiobookshelf";
    };

    bazarr = {
      enable = true;
      package = pkgs.unstable.bazarr;
      openFirewall = true;
      stateDir = "/data/.state/bazarr";
    };
    
    lidarr = {
      enable = true;
      package = pkgs.unstable.lidarr;
      openFirewall = true;
      stateDir = "/data/.state/lidarr";
    };
    
    prowlarr = {
      enable = true;
      package = pkgs.unstable.prowlarr;
      openFirewall = true;
      stateDir = "/data/.state/prowlarr";
    };

    radarr = {
      enable = true;
      package = pkgs.unstable.radarr;
      openFirewall = true;
      stateDir = "/data/.state/radarr";
    };
    
    sonarr = {
      enable = true;
      package = pkgs.unstable.sonarr;
      openFirewall = true;
      stateDir = "/data/.state/sonarr";
    };
  };
}
