{ config, lib, ... }:
{
  flake.modules.homeManager.flutter =
    { pkgs, ... }:
    {
      home.packages = lib.optionals (pkgs.stdenv.hostPlatform.system != "aarch64-linux") [
        pkgs.flutter
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.flutter;
}
