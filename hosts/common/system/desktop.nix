{ config, pkgs, ... }:

{
  boot = {
    # Animation
     plymouth.enable = true;
     
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    channel = "https://channels.nixos.org/nixos-unstable";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };
}
