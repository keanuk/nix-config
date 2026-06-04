{ config, ... }:
{
  configurations.nixos.luna.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "25.11";
  };

  configurations.homeManager."keanu@luna" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        gaming
      ];
      home.stateVersion = "25.11";
    };
  };
}
