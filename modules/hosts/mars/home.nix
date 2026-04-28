{ config, ... }:
{
  configurations.nixos.mars.module = {
    home-manager.users.keanu = {
      imports = [ config.flake.modules.homeManager.wsl ];
      home = {
        username = "keanu";
        homeDirectory = "/home/keanu";
        stateVersion = "25.11";
      };
    };
  };

  configurations.homeManager."keanu@mars" = {
    system = "aarch64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.wsl ];
      home = {
        username = "keanu";
        homeDirectory = "/home/keanu";
        stateVersion = "25.11";
      };
    };
  };
}
