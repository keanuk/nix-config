{ config, ... }:
{
  configurations.nixos.titan.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "23.11";
  };

  configurations.homeManager."keanu@titan" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        gaming
      ];
      home.stateVersion = "23.11";
    };
  };
}
