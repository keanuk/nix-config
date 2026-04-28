{ config, ... }:
{
  flake.modules.homeManager.lua =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lua
        lua-language-server
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.lua;
}
