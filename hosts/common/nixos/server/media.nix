{ config, pkgs, lib, ... }:

{
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    plex = {
      enable = true;
      user = "keanu";
      openFirewall = true;
    };
  };
}