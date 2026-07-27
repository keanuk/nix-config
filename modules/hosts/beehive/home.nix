{ config, ... }:
let
  beehiveHome = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    xdg.configFile."niri/outputs.kdl".text = ''
      output "LG Electronics LG TV SSCR2 0x01010101" {
          scale 2.0
      }
    '';
  };
in
{
  configurations.nixos.beehive.module.home-manager.users.keanu = beehiveHome // {
    home.stateVersion = "25.05";
  };

  configurations.homeManager."keanu@beehive" = {
    system = "x86_64-linux";
    module = beehiveHome // {
      home.stateVersion = "26.11";
    };
  };
}
