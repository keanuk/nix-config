{ config, ... }:
{
  configurations.nixos.earth.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "23.11";
  };
}
