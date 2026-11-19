{ config, ... }:
{
  configurations.nixos.luna.homeUsers.keanu = {
    imports = with config.flake.modules.homeManager; [
      desktop-linux
      gaming
    ];
    home.stateVersion = "26.11";
  };
}
