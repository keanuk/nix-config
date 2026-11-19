{ config, ... }:
{
  configurations.nixos.tethys.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "23.05";
  };
}
