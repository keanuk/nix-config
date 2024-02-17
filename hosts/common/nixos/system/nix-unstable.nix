{ config, pkgs, ... }:

{
  boot = {
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    channel = "https://channels.nixos.org/nixos-unstable";
  };
}
