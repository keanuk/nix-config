{ config, ... }:
{
  configurations.nixos.miranda.homeUsers.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "25.05";
  };
}
