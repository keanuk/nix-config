{
  flake.modules.homeManager.desktop =
    { lib, pkgs, ... }:
    {
      services.amberol = {
        enable = true;
        enableRecoloring = true;
        replaygain = "album";
        package = lib.mkDefault pkgs.amberol;
      };
    };
}
