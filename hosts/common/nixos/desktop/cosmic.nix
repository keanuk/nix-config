{ pkgs, ... }: {
  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.cosmic-greeter.enable = true;

  # Needed if not using GNOME
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    tasks
  ];
}
