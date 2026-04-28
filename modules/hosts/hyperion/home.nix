{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "23.11";
  };
  kimmyHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      desktop
      gnome
      gaming
    ];
    home = {
      username = "kimmy";
      homeDirectory = "/home/kimmy";
      stateVersion = "23.11";
    };
  };
in
{
  configurations.nixos.hyperion.module.home-manager.users = {
    keanu = keanuHome;
    kimmy = kimmyHome;
  };

  configurations.homeManager."keanu@hyperion" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
  configurations.homeManager."kimmy@hyperion" = {
    system = "x86_64-linux";
    module = kimmyHome;
  };
}
