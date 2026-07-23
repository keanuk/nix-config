{ config, ... }:
{
  configurations.nixos.beehive.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    home.stateVersion = "25.05";
  };

  configurations.homeManager."keanu@beehive" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        noctalia
        niri
      ];
      home.stateVersion = "25.05";
    };
  };
}
