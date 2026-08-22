{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
      noctalia
      niri
    ];
    home.stateVersion = "26.11";
  };
in
{
  configurations.nixos.luna.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@luna" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
