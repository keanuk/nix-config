{ config, pkgs, lib, ... }:

{
  services = {
    lidarr = {
      enable = true;
    };

    prowlarr = {
      enable = true;
    };

    radarr = {
      enable = true;
    };
    
    sonarr = {
      enable = true;
    };

    # Download
    transmission = {
      enable = true;
    };
  };
}