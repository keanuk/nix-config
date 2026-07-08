{ config, ... }:
{
  configurations.nixos-stable.beehive.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.desktop-linux ];
    home.stateVersion = "25.05";
  };

  configurations.homeManager-stable."keanu@beehive" = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.desktop-linux ];
      home.stateVersion = "25.05";
    };
  };
}
