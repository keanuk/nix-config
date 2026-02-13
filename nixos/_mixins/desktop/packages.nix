{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gsmartcontrol
    snapper-gui
    vulkan-tools
    wireplumber

    xkill
  ];
}
