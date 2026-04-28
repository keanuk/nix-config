{ config, ... }:
{
  flake.modules.homeManager.desktop-linux = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      desktop
      cosmic-tray
      gnome-tray
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
    };
  };
}
