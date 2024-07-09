{ pkgs, ... }:

{
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasma";
    sddm.wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Needed if not using GNOME
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = [
    pkgs.kdePackages.discover
  ];

  qt.enable = true;
} 
