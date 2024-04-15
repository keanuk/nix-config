{ pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  users.users.keanu.packages = with pkgs; [
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.tailscale-qs
  ];
}
