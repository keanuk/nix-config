{ config, ... }:
{
  flake.modules.homeManager.vps-profile = {
    imports = with config.flake.modules.homeManager; [
      base
    ];

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
    };
  };
}
