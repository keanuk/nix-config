{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  users.users.keanu.packages = with pkgs; [
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.tailscale-qs
  ];
}
