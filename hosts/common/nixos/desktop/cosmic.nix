{ pkgs, ... }:

{
  services.desktopManager.cosmic.enable = true; 
  services.displayManager.cosmic-greeter.enable = true;
  
  environment.systemPackages = with pkgs; [
    cosmic-applets
    cosmic-applibrary
    cosmic-bg
    cosmic-comp
    cosmic-edit
    cosmic-files
    cosmic-greeter
    cosmic-icons
    cosmic-launcher
    cosmic-notifications
    cosmic-osd
    cosmic-panel
    cosmic-protocols
    cosmic-randr
    cosmic-screenshot
    cosmic-settings
    cosmic-settings-daemon
    cosmic-term
    cosmic-workspaces-epoch
    xdg-desktop-portal-cosmic
  ];
}
