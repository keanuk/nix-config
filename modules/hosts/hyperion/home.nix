{ config, ... }:
{
  configurations.nixos.hyperion.homeUsers = {
    keanu = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        gaming
      ];
      home.stateVersion = "23.11";
    };

    kimmy = {
      imports = with config.flake.modules.homeManager; [
        base
        desktop
        noctalia
        niri
        umbriel
        gaming
      ];
      home = {
        username = "kimmy";
        homeDirectory = "/home/kimmy";
        stateVersion = "23.11";
      };
    };
  };
}
