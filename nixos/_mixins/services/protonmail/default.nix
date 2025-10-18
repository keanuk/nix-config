{pkgs, ...}: {
  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge-gui;
    path = with pkgs; [
      pass
      gnome-keyring
    ];
  };
}
