{ config, ... }:
{
  configurations.nixos.earth.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      noctalia
      niri
    ];
    home.stateVersion = "23.11";
  };

  configurations.homeManager."keanu@earth" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.homeManager; [
        desktop-linux
        noctalia
        niri
      ];
      home.stateVersion = "23.11";
    };
  };
}
