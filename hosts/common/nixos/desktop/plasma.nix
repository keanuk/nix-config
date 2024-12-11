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

  environment.systemPackages = with pkgs; [
    kdePackages.discover
    kdePackages.kmail
    kdePackages.konversation
    kdePackages.neochat
  ];

  qt.enable = true;
}
