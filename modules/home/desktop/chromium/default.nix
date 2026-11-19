{ config, ... }:
{
  flake.modules.homeManager.chromium =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.chromium;
}
