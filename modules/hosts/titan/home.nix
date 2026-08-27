{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
      noctalia
      niri
    ];
    xdg.configFile."niri/outputs.kdl".text = ''
      output "Microstep MAG321CURV DA2A059320051" {
          scale 1.5
      }
      output "HP Inc. HP E24 G4 CN42256419" {
          transform "270"
      }
    '';
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
