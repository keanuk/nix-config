{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    distrobox
    gsmartcontrol
    snapper-gui
    wireplumber

    xorg.xkill
  ];
}
