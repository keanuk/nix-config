{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    ptyxis
    snapper-gui
    wireplumber

    xorg.xkill
  ];
}
