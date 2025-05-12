{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    distrobox
    gsmartcontrol
    ptyxis
    snapper-gui
    wireplumber

    xorg.xkill
  ];
}
