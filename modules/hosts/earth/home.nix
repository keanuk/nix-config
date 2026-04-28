{ config, ... }:
{
  configurations.nixos.earth.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "23.11";
  };

  configurations.homeManager."keanu@earth" = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.desktop-linux ];
      home.stateVersion = "23.11";
    };
  };
}
