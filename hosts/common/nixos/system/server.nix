{ config, pkgs, ... }:

{
  boot = {
    # Animation
     plymouth.enable = false;
     
    # Kernel
    kernelPackages = pkgs.linuxPackages_hardened;
  };

  # Upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    channel = "https://channels.nixos.org/nixos-23.05";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
}
