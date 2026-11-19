{ config, ... }:
{
  flake.modules.homeManager.ptyxis =
    { pkgs, ... }:
    {
      programs.ptyxis = {
        enable = true;
        package = pkgs.ptyxis;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.ptyxis;
}
