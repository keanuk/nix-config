{ config, ... }:
{
  configurations.nixos.titan.homeUsers.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    xdg.configFile = {
      "niri/outputs.kdl".text = ''
        output "Microstep MAG321CURV DA2A059320051" {
            scale 1.5
        }
        output "HP Inc. HP E24 G4 CN42256419" {
            transform "270"
        }
      '';
      "umbriel/outputs.toml".text = ''
        [output."Microstep MAG321CURV DA2A059320051"]
        scale = 1.5
        position = [ 1080, 0 ]

        [output."HP Inc. HP E24 G4 CN42256419"]
        transform = "270"
        position = [ 0, 0 ]
      '';
    };
    home.stateVersion = "23.11";
  };
}
