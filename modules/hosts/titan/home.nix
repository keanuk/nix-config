{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
      noctalia
      niri
    ];
    home.stateVersion = "23.11";
  };
in
{
  configurations.nixos.titan.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@titan" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
