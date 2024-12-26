{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    catppuccin
    distrobox
    ptyxis
    snapper-gui
    wireplumber

    xorg.xkill
  ];
}
