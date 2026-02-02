{ pkgs, ... }:
{
  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.cosmic-greeter.enable = true;

  environment.systemPackages = with pkgs; [
    cosmic-ext-applet-caffeine
    cosmic-ext-applet-minimon
    cosmic-ext-applet-privacy-indicator
    cosmic-ext-applet-sysinfo
    cosmic-ext-applet-weather
    cosmic-ext-tweaks
  ];
}
