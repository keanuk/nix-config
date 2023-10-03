{ config, pkgs, lib, ... }:

{
  services = {
    
    # Security
    adguardhome = {
      enable = true;
    };

    # Smart home
    home-assistant = {
      enable = true;
    };
    
  };
}