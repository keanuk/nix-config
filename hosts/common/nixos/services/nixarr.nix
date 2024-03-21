{ inputs, ... }:

{
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;

    mediaDir = "/internal/media";
    stateDir = "/var/lib/nixarr";

    vpn = {
      enable = true;
      wgConf = "/home/keanu/secrets/wg0.conf";
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 51413;
      uiPort = 9091;
      extraAllowedIps = [
        "10.19.5.*"
      ];
    };

    jellyfin = {
      enable = true;
    };

    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
  };
}
