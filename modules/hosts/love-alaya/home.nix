{ config, ... }:
{
  configurations.nixos-stable.love-alaya.homeUsers.keanu = {
    imports = [ config.flake.modules.homeManager.vps-profile ];
    home.stateVersion = "25.11";
  };
}
