{ config, ... }:
{
  configurations.nixos.tethys.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "23.05";
  };

  configurations.homeManager."keanu@tethys" = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.desktop-linux ];
      home.stateVersion = "23.05";
    };
  };
}
