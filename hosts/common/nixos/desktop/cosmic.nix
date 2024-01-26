{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cosmic-applets
    cosmic-comp
    cosmic-edit
    cosmic-greeter
    cosmic-icons
    cosmic-launcher
    cosmic-osd
    cosmic-panel
    cosmic-settings
    cosmic-term
    cosmic-workspaces-epoch
  ];
}
