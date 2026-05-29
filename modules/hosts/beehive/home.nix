{ config, ... }:
let
  beehiveKeanuHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      server
      pass
      # openclaw
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "25.05";
    };
  };
in
{
  configurations.nixos-stable.beehive.module.home-manager.users.keanu = beehiveKeanuHome;

  configurations.homeManager-stable."keanu@beehive" = {
    system = "x86_64-linux";
    module = beehiveKeanuHome;
  };
}
