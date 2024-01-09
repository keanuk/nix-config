{ config, pkgs, ... }:

{
  # Power management
  services = {
    power-profiles-daemon.enable = true;
  	thermald.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
