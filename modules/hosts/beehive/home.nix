{ config, ... }:
{
  configurations.nixos.beehive.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    xdg.configFile = {
      "niri/outputs.kdl".text = ''
        output "LG Electronics LG TV SSCR2 0x01010101" {
            scale 2.0
        }
      '';
      "umbriel/outputs.toml".text = ''
        [output."LG Electronics LG TV SSCR2 0x01010101"]
        scale = 2.0
      '';
    };
    home.stateVersion = "26.11";
  };
}
