{ config, ... }:
{
  configurations.nixos.phoebe.module.home-manager.users.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "25.11";
  };

  configurations.homeManager."keanu@phoebe" = {
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
