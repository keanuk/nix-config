{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
      noctalia
      niri
    ];
    home.stateVersion = "25.05";
  };
in
{
  configurations.nixos.miranda.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@miranda" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
