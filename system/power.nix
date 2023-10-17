{ config, pkgs, ... }:

{
  # Power management
  services = {
    power-profiles-daemon.enable = true;
  	thermald.enable = true;
  	auto-cpufreq.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
