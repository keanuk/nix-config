{ config, ... }:
{
  flake.modules.homeManager.darwin-profile = {
    imports = with config.flake.modules.homeManager; [
      base
      darwin
    ];

    home = {
      username = "keanu";
      homeDirectory = "/Users/keanu";
    };
  };
}
