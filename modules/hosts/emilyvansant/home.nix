{ config, ... }:
{
  configurations.nixos-stable.emilyvansant.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.vps-profile ];
    home.stateVersion = "25.11";
  };
}
