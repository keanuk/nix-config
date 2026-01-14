{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    hyprland-protocols
  ];
}
