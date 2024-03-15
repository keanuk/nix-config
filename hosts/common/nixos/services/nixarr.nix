{ inputs, ... }:

{
	imports = [
    inputs.nixarr.nixosModules.default
	];

  nixarr = {
    enable = true;

    mediaDir = "/internal/media";
    stateDir = "/var/lib/nixarr";

    # vpn = {
    #   enable = true;
    #   wgConf = "/home/keanu/.secrets/wg0.conf";
    # };

    transmission = {
      enable = true;
      openFirewall = true;
      # vpn.enable = true;
      # peerPort = 50000;
      uiPort = 9091;
      # flood.enable = true;
      extraAllowedIps = [
        "10.19.5.10"
      ];
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
