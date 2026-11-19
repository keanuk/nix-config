{ config, ... }:
{
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      programs.discord = {
        enable = true;
        package = pkgs.discord;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.discord;
}
