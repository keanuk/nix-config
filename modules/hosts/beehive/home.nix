{ config, ... }:
{
  configurations.nixos.beehive.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "25.05";
  };

  configurations.homeManager."keanu@beehive" = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.desktop-linux ];
      home.stateVersion = "25.05";
    };
  };
}
