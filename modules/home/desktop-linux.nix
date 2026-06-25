{ config, ... }:
{
  flake.modules.homeManager.desktop-linux = {
    imports = with config.flake.modules.homeManager; [
      base
      sops
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
