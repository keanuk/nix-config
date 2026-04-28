{ config, ... }:
{
  flake.modules.homeManager.flutter =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        flutter
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.flutter;
}
