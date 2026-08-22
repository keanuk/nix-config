{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
      noctalia
      niri
    ];
    home.stateVersion = "25.11";
  };
in
{
  configurations.nixos.phoebe.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@phoebe" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
