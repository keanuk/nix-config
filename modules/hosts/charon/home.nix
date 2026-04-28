{ config, ... }:
{
  configurations.darwin.charon.module.home-manager.users.keanu = {
    imports = [ config.flake.modules.homeManager.darwin-profile ];
    home.stateVersion = "24.05";
  };

  configurations.homeManager."keanu@charon" = {
    system = "x86_64-darwin";
    module = {
      imports = [ config.flake.modules.homeManager.darwin-profile ];
      home.stateVersion = "24.05";
    };
  };
}
