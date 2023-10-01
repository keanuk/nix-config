{ config, pkgs, lib, ... }

{
  services = {

    # Media management

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