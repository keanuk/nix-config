{ config, ... }:
{
  configurations.nixos.mars.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.wsl ];
    home.stateVersion = "25.11";
  };
}
