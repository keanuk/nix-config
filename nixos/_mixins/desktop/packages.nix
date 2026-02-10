{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox
    gsmartcontrol
    snapper-gui
    vulkan-tools
    wireplumber

    xkill
  ];
}
