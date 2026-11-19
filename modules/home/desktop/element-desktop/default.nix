{ config, ... }:
{
  flake.modules.homeManager.element-desktop =
    { pkgs, ... }:
    {
      programs.element-desktop = {
        enable = true;
        package = pkgs.element-desktop;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.element-desktop;
}
