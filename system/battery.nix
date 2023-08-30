{ config, pkgs, ... }:

{
  # Power management
  services = {
  	thermald.enable = true;
  	auto-cpufreq.enable = true;
  };

  powerManagement.powertop.enable = true;
}
