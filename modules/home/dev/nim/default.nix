{ config, ... }:
{
  flake.modules.homeManager.nim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nim
        nimlangserver
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.nim;
}
