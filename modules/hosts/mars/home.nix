{ config, ... }:
let
  keanuHome = {
    imports = [ config.flake.modules.homeManager.wsl ];
    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "25.11";
    };
  };
in
{
  configurations.nixos.mars.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@mars" = {
    system = "aarch64-linux";
    module = keanuHome;
  };
}
