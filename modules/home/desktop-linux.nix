{ config, ... }:
{
  flake.modules.homeManager.desktop-linux = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      desktop
      cosmic
      gnome
      zellij
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
    };
  };
}
