{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    home.stateVersion = "23.05";
  };
in
{
  configurations.nixos.tethys.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@tethys" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
