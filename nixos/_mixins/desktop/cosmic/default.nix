{ pkgs, ... }:
{
  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.cosmic-greeter.enable = true;

  environment.systemPackages = with pkgs; [
    cosmic-ext-applet-caffeine
    cosmic-ext-tweaks
  ];
}
