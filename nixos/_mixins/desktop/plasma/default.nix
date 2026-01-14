{ pkgs, ... }:
{
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasma";
    sddm.wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.discover
    kdePackages.kmail
    kdePackages.konversation
    kdePackages.neochat
  ];

  qt.enable = true;
}
