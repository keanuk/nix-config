{ config, ... }:
let
  ursaKeanuHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      server
      pass
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "26.05";
    };
  };
in
{
  configurations.nixos-stable.ursa.module.home-manager.users.keanu = ursaKeanuHome;

  configurations.homeManager-stable."keanu@ursa" = {
    system = "x86_64-linux";
    module = ursaKeanuHome;
  };
}
