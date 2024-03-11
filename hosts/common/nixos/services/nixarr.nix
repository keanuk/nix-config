{ inputs, ... }:

{
	imports = [
    inputs.nixarr.nixosModules.default
	];

  nixarr = {
    enable = true;

    mediaDir = "/data/Media";
    stateDir = "/data/Media/.state";

    vpn = {
      enable = true;
      wgConf = "/home/keanu/.secrets/wg0.conf";
    };

    transmission = {
      enable = true;
      vpn.enable = true;      
    };

    jellyfin = {
      enable = true;
    };

    sonarr.enable = true;
    radarr.enable = true;
    prowlarr.enable = true;
    readarr.enable = true;
    lidarr.enable = true;
  };
}
