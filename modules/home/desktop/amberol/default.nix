{ config, ... }:
{
  flake.modules.homeManager.amberol =
    { lib, pkgs, ... }:
    {
      services.amberol = {
        enable = true;
        enableRecoloring = true;
        replaygain = "album";
        package = lib.mkDefault pkgs.amberol;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.amberol;
}
