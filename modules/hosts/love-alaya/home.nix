{ config, ... }:
let
  keanuHome = {
    imports = [ config.flake.modules.homeManager.vps-profile ];
    home.stateVersion = "25.11";
  };
in
{
  configurations.nixos-stable.love-alaya.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager-stable."keanu@love-alaya" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
