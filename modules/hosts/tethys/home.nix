{ config, ... }:
{
  configurations.nixos.tethys.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    home.stateVersion = "23.05";
  };

  configurations.homeManager."keanu@tethys" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        noctalia
        niri
      ];
      home.stateVersion = "23.05";
    };
  };
}
