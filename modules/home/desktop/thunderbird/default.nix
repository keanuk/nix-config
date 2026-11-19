{ config, ... }:
{
  flake.modules.homeManager.thunderbird =
    { pkgs, ... }:
    {
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird-latest;
        profiles = {
          "main" = {
            isDefault = true;
          };
        };
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.thunderbird;
}
