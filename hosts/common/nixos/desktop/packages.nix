{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    gsmartcontrol
    gtk4
    ptyxis
    snapper-gui
    wireplumber
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr

    xorg.xkill
  ];
}
