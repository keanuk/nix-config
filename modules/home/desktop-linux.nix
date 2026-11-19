{ config, ... }:
{
  flake.modules.homeManager.desktop-linux = {
    imports = with config.flake.modules.homeManager; [
      base
      desktop
      noctalia
      niri
      umbriel
      zellij
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
    };
  };
}
