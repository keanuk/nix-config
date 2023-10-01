{ config, pkgs, lib, ... }

{
  services = {
    jellyfin = {
      enable = true;
    };

    plex = {
      enable = true;
    };
  };
}