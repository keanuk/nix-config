{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    home.stateVersion = "23.11";
  };
in
{
  configurations.nixos.earth.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@earth" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
