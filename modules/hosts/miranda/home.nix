{ config, ... }:
{
  configurations.nixos.miranda.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "25.05";
  };

  configurations.homeManager."keanu@miranda" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        gaming
      ];
      home.stateVersion = "25.05";
    };
  };
}
