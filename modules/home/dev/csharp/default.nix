{ config, ... }:
{
  flake.modules.homeManager.csharp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dotnet-sdk_8
        mono
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.csharp;
}
