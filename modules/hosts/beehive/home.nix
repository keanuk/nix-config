{ config, ... }:
let
  keanuHome = {
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
    home.stateVersion = "26.11";
  };
in
{
  configurations.nixos.beehive.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@beehive" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
