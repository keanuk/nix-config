{ config, ... }:
{
  configurations.nixos-stable.love-alaya.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.vps-profile ];
    home.stateVersion = "25.11";
  };

  configurations.homeManager-stable."keanu@love-alaya" = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.vps-profile ];
      home.stateVersion = "25.11";
    };
  };
}
