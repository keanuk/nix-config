{ config, ... }:
let
  keanuHome = {
    imports = [ config.flake.modules.homeManager.vps-profile ];
    home.stateVersion = "25.11";
  };
in
{
  configurations.nixos-stable.emilyvansant.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager-stable."keanu@emilyvansant" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
