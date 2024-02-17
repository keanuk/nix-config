{ config, pkgs, lib, ... }:

{
  services = {
    adguardhome = {
      enable = true;
    };

    home-assistant = {
      enable = true;
      config = ./home-assistant/config/configuration.yaml;
    };
  };
}